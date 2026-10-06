# frozen_string_literal: true

require "bigdecimal"

module Peddler
  module Native
    UINT64_MAX = (1 << 64) - 1

    class << self
      def valid_utf8_string?(value)
        return false unless value.is_a?(String) && value.valid_encoding?
        return true if value.encoding == Encoding::UTF_8 || value.ascii_only?

        value.encode(Encoding::UTF_8)
        true
      rescue EncodingError
        false
      end
    end

    module TransferConfig
      class << self
        def json(options)
          compressions = [:auto, :gzip]
          limits = [:max_bytes, :max_record_bytes]
          unless (options.keys - (limits + [:timeout, :compression])).empty?
            raise ArgumentError, "invalid document configuration"
          end
          options.each do |key, value|
            valid = case key
            when :timeout then Native.positive_seconds?(value)
            when :compression then compressions.include?(value)
            else value.is_a?(Integer) && value.positive? && value <= UINT64_MAX
            end
            raise ArgumentError, "invalid document configuration" unless valid
          end
          Native.generate(options) || raise(ArgumentError, "invalid document configuration")
        end
      end
    end

    module Uploads
      CHUNK_BYTES = 64 * 1024

      class << self
        # A String or read(length) source, and a length that fits in 64 bits when one is declared
        def valid?(source, content_length)
          (content_length.nil? || (content_length.is_a?(Integer) && content_length >= 0 && content_length <= UINT64_MAX)) &&
            (source.is_a?(String) || source.respond_to?(:read))
        end

        # The declared length, or a String's own. A body without one goes out chunked.
        def length(source, content_length)
          content_length || (source.bytesize if source.is_a?(String))
        end

        # Uploads the source to a signed URL and returns the response
        def put(engine, url, source, content_type, headers, content_length, transfer_options)
          unless Native.valid_utf8_string?(url) && Native.valid_utf8_string?(content_type) && headers.is_a?(Hash) &&
              headers.all? { |key, value| Native.valid_utf8_string?(key) && Native.valid_utf8_string?(value) } &&
              valid?(source, content_length)
            raise ArgumentError, "invalid document upload configuration"
          end
          upload = engine.start_document_upload(url, TransferConfig.json(transfer_options), content_type, headers.to_a,
            length(source, content_length))
          begin
            drain(upload, source)
            Response.from_parts(upload.finish)
          ensure
            upload.close
          end
        end

        # Feed an upload handle from a String or read(length) source until the source ends
        # or the transfer completes early. Source exceptions stay the cause of a fixed error.
        def drain(upload, source)
          offset = 0
          until upload.completed?
            chunk = if source.is_a?(String)
              value = source.byteslice(offset, CHUNK_BYTES)
              offset += CHUNK_BYTES
              value
            else
              begin
                source.read(CHUNK_BYTES)
              rescue StandardError
                raise DocumentError, "document upload source failed"
              end
            end
            break if chunk.nil? || chunk == ""
            raise DocumentError, "document upload source failed" unless chunk.is_a?(String) && chunk.bytesize <= CHUNK_BYTES
            break unless upload.push(chunk)
          end
        end
      end
    end
  end

  class Document
    # How a document's JSON is read: exact decimals, any depth, and the last value of a repeated key
    JSON_OPTIONS = { decimal_class: BigDecimal, max_nesting: false, allow_duplicate_key: true }.freeze
    private_constant :JSON_OPTIONS

    def initialize(handle)
      @handle = handle
    end

    def headers = @handle.headers
    def charset = @handle.charset
    def closed? = @handle.closed?
    def close = @handle.close
    def inspect = "#<Peddler::Document>"

    def each_chunk(&block)
      return enum_for(:each_chunk) unless block

      each_row("chunks", &block)
    end

    def each_jsonl
      return enum_for(:each_jsonl) unless block_given?

      each_row("jsonl") { |record| yield JSON.parse(record, **JSON_OPTIONS) }
    end

    def each_tsv(charset: nil, &block)
      return enum_for(:each_tsv, charset: charset) unless block

      each_row("tsv", charset, &block)
    end

    def json(max_bytes:)
      unless max_bytes.is_a?(Integer) && max_bytes.positive? && max_bytes <= Native::UINT64_MAX
        raise ArgumentError, "invalid document configuration"
      end
      JSON.parse(@handle.json(max_bytes), **JSON_OPTIONS)
    ensure
      close
    end

    private

    # Yields each row, then closes the document, also when the arguments are invalid or the block breaks or raises
    def each_row(mode, charset = nil)
      raise ArgumentError, "invalid document configuration" unless charset.nil? || Native.valid_utf8_string?(charset)

      while (row = @handle.next_row(mode, charset))
        yield row
      end
      self
    ensure
      close
    end
  end

  class Client
    # Opens the document at a signed URL
    #
    # @raise [Peddler::Error] if the URL answers outside 2xx
    def download_document(url, **transfer_options, &block)
      raise ArgumentError, "invalid document URL" unless Native.valid_utf8_string?(url)

      open_document(@engine.download_document(url, Native::TransferConfig.json(transfer_options)), &block)
    end

    # Uploads a String or a `read(length)` source to a signed URL
    #
    # @return [Peddler::Response]
    # @raise [Peddler::Error] if the URL answers outside 2xx
    def upload_document(url, source, content_type:, headers: {}, content_length: nil, **transfer_options)
      Native::Uploads.put(@engine, url, source, content_type, headers, content_length, transfer_options)
    end

    private

    # The document, or what the block returns with the document closed after it
    def open_document(handle)
      document = Document.new(handle)
      return document unless block_given?

      begin
        yield document
      ensure
        document.close
      end
    end
  end
end
