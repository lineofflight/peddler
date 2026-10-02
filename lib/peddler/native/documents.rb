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
          compressions = [:auto, :none, :gzip]
          limits = [:max_bytes, :max_record_bytes, :max_records, :max_response_bytes]
          unless (options.keys - (limits + [:timeout, :compression])).empty?
            raise ArgumentError, "invalid document configuration"
          end
          options.each do |key, value|
            valid = case key
            when :timeout then (value.is_a?(Integer) || value.is_a?(Float)) && value.finite? && value > 0
            when :compression then compressions.include?(value)
            else value.is_a?(Integer) && value.positive? && value <= UINT64_MAX
            end
            raise ArgumentError, "invalid document configuration" unless valid
          end
          JSON.generate(options)
        rescue JSON::GeneratorError, TypeError
          raise ArgumentError, "invalid document configuration", cause: nil
        end
      end
    end

    # JSON only invokes this on decimal tokens already validated by Rust.
    module DocumentDecimal
      class << self
        def try_convert(text)
          value = BigDecimal(text)
          significand = text.split(/[eE]/, 2).first || ""
          if !value.finite? || (value.zero? && significand.match?(/[1-9]/))
            raise DocumentError, "document decimal is out of range"
          end
          value
        rescue ArgumentError, RangeError
          raise DocumentError, "document decimal is out of range", cause: nil
        end
      end
    end

    module Uploads
      CHUNK_BYTES = 64 * 1024

      class << self
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
    def initialize(handle)
      @handle = handle
    end

    def status = @handle.status
    def headers = @handle.headers
    def error_body = @handle.error_body
    def error_body_truncated? = @handle.error_body_truncated?
    def closed? = @handle.closed?
    def close = @handle.close
    def inspect = "#<Peddler::Document>"

    def each_chunk
      return enum_for(:each_chunk) unless block_given?

      begin
        while (chunk = @handle.next_row("chunks", false))
          yield chunk
        end
      ensure
        close
      end
      self
    end

    def each_jsonl
      return enum_for(:each_jsonl) unless block_given?

      begin
        while (record = @handle.next_row("jsonl", false))
          yield JSON.parse(record, decimal_class: Native::DocumentDecimal, max_nesting: false)
        end
      ensure
        close
      end
      self
    end

    def each_tsv(consistent_fields: false)
      return enum_for(:each_tsv, consistent_fields: consistent_fields) unless block_given?

      begin
        unless consistent_fields == true || consistent_fields == false
          raise ArgumentError, "invalid document configuration"
        end
        while (row = @handle.next_row("tsv", consistent_fields))
          yield row
        end
      ensure
        close
      end
      self
    end

    def json(max_bytes:)
      unless max_bytes.is_a?(Integer) && max_bytes.positive? && max_bytes <= Native::UINT64_MAX
        raise ArgumentError, "invalid document configuration"
      end
      JSON.parse(@handle.json(max_bytes), decimal_class: Native::DocumentDecimal, max_nesting: false)
    ensure
      close
    end
  end

  class Client
    def download_document(url, **transfer_options)
      raise ArgumentError, "invalid document URL" unless Native.valid_utf8_string?(url)

      document = Document.new(@engine.download_document(url, Native::TransferConfig.json(transfer_options)))
      return document unless block_given?

      begin
        yield document
      ensure
        document.close
      end
    end

    def upload_document(url, source, content_type:, headers: {}, content_length: nil, **transfer_options)
      unless Native.valid_utf8_string?(url) && Native.valid_utf8_string?(content_type) && headers.is_a?(Hash) &&
          headers.all? { |key, value| Native.valid_utf8_string?(key) && Native.valid_utf8_string?(value) } &&
          (content_length.nil? || (content_length.is_a?(Integer) && content_length >= 0 && content_length <= Native::UINT64_MAX)) &&
          (source.is_a?(String) || source.respond_to?(:read))
        raise ArgumentError, "invalid document upload configuration"
      end
      upload = @engine.start_document_upload(url, Native::TransferConfig.json(transfer_options), content_type, headers.to_a, content_length)
      begin
        Native::Uploads.drain(upload, source)
        Response.from_document_parts(upload.finish)
      ensure
        upload.close
      end
    end
  end
end
