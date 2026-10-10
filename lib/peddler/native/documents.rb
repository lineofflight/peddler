# frozen_string_literal: true

require "bigdecimal"

module Peddler
  module Native
    UINT64_MAX = (1 << 64) - 1 #: Integer

    #: (untyped value) -> bool
    def self.valid_utf8_string?(value)
      return false unless value.is_a?(String) && value.valid_encoding?
      return true if value.encoding == Encoding::UTF_8 || value.ascii_only?

      value.encode(Encoding::UTF_8)
      true
    rescue EncodingError
      false
    end

    # The options of a transfer. An error names the option and its rule, never a value. It doesn't repeat an
    # option it doesn't know either: that is the caller's own text.
    module TransferConfig
      COMPRESSIONS = [:auto, :gzip].freeze #: Array[Symbol]
      LIMITS = [:max_bytes, :max_record_bytes].freeze #: Array[Symbol]
      UNKNOWN = "unknown option: the options are timeout, compression, max_bytes and max_record_bytes"
      private_constant :COMPRESSIONS, :LIMITS, :UNKNOWN

      # The options as the JSON the engine takes
      #: (Hash[untyped, untyped] options) -> String
      def self.json(options)
        options.each do |name, value|
          case name
          when :timeout then Native.timeout(value)
          when :compression
            raise ArgumentError, "compression must be :auto or :gzip" unless COMPRESSIONS.include?(value)
          when *LIMITS then limit(name, value)
          else raise ArgumentError, UNKNOWN
          end
        end
        Native.generate(options) || raise(ArgumentError, "invalid document configuration")
      end

      # A limit in bytes as it is, or the error that names it
      #: (Symbol name, untyped value) -> Integer
      def self.limit(name, value)
        return value if value.is_a?(Integer) && value.between?(1, UINT64_MAX)

        raise ArgumentError, "#{name} must be a positive Integer that fits in 64 bits"
      end
    end

    # The document, or what the block returns with the document closed after it
    #: [T] (DocumentHandle handle) ?{ (Document document) -> T } -> (T | Document)
    def self.open_document(handle)
      document = Document.new(handle)
      return document unless block_given?

      begin
        yield document
      ensure
        document.close
      end
    end

    module Uploads
      CHUNK_BYTES = 64 * 1024 #: Integer

      # Raises unless the source is a String or a read(length) source, and its length, when one is declared, fits in
      # 64 bits
      #: (untyped source, untyped content_length) -> void
      def self.check(source, content_length)
        unless source.is_a?(String) || source.respond_to?(:read)
          raise ArgumentError, "source must be a String or respond to read"
        end
        return if content_length.nil? || (content_length.is_a?(Integer) && content_length.between?(0, UINT64_MAX))

        raise ArgumentError, "content_length must be an Integer from 0 that fits in 64 bits"
      end

      # The declared length, a String's own, or the size a source answers, as v5 sent it, less its position when
      # it answers one, as a File and a StringIO do. A body without a length goes out chunked.
      #: (untyped source, Integer? content_length) -> Integer?
      def self.length(source, content_length)
        return content_length if content_length
        return source.bytesize if source.is_a?(String)
        return unless source.respond_to?(:size)

        left = source.size
        left -= source.pos if source.respond_to?(:pos)
        left if left.is_a?(Integer) && left.between?(0, UINT64_MAX)
      rescue StandardError
        # A source that can't tell, as a File on a pipe can't say where it is
        nil
      end

      # Uploads the source to a signed URL and returns the response
      #: (Engine engine, untyped url, untyped source, untyped content_type, untyped headers, untyped content_length, Hash[Symbol, untyped] transfer_options) -> Response
      def self.put(engine, url, source, content_type, headers, content_length, transfer_options)
        raise ArgumentError, "invalid document URL" unless Native.valid_utf8_string?(url)
        raise ArgumentError, "content_type must be a UTF-8 String" unless Native.valid_utf8_string?(content_type)
        unless headers.is_a?(Hash) && headers.all? { |pair| pair.all? { |text| Native.valid_utf8_string?(text) } }
          raise ArgumentError, "headers must be a Hash of UTF-8 Strings"
        end

        check(source, content_length)
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
      #: (UploadHandle upload, String | (_DocumentIO & Object) source) -> void
      def self.drain(upload, source)
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

  # A document that is read as it downloads, so that a large one doesn't have to fit in memory
  #
  # `open_report_document`, `open_feed_document` and `open_query_document` on the API views open one by its ID,
  # and {Peddler::Client#download_document} by its signed URL. A document Amazon compressed is decompressed.
  #
  # A document is read once, in one way: {#each_tsv}, {#each_jsonl}, {#each_chunk} or {#json}. Reading it closes
  # it, also when the block breaks or raises. A document that is closed, or already read another way, raises
  # {Peddler::DocumentError}.
  #
  # @example
  #   client.reports.open_report_document(report.report_document_id) do |document|
  #     document.each_tsv { |row| puts row.first }
  #   end
  class Document
    # @rbs @handle: Native::DocumentHandle

    # How a document's JSON is read: exact decimals, any depth, and the last value of a repeated key
    JSON_OPTIONS = { decimal_class: BigDecimal, max_nesting: false, allow_duplicate_key: true }.freeze #: Hash[Symbol, untyped]
    private_constant :JSON_OPTIONS

    # @!visibility private
    #: (Native::DocumentHandle handle) -> void
    def initialize(handle)
      @handle = handle
    end

    # @rbs return: Response::Headers -- the headers of the download, as a response answers them
    def headers = Response::Headers.new(@handle.headers)

    # @rbs return: String? -- the charset parameter of the document's Content-Type, as Amazon sent it
    def charset = @handle.charset

    #: () -> bool
    def closed? = @handle.closed?

    # Ends the download and frees its connection. A document that is closed stays closed.
    #: () -> void
    def close = @handle.close

    #: () -> String
    def inspect = "#<Peddler::Document>"

    # Yields the bytes of the document as they arrive
    #
    # Without a block it returns an Enumerator.
    #
    # @raise [Peddler::DocumentTimeoutError] if the download runs past its timeout
    # @raise [Peddler::DocumentError] if the transfer breaks or the document is larger than `max_bytes`
    #: () { (String chunk) -> void } -> Document
    #: () -> Enumerator[String, Document]
    def each_chunk(&block)
      return enum_for(:each_chunk) unless block

      each_row("chunks", &block)
    end

    # Yields each line of a JSON Lines document, such as a Data Kiosk result, parsed
    #
    # A number with a fraction parses as a BigDecimal. A line of whitespace is skipped. Without a block it returns
    # an Enumerator.
    #
    # @raise [Peddler::DocumentTimeoutError] if the download runs past its timeout
    # @raise [Peddler::DocumentError] if the transfer breaks, a line is not JSON or one is larger than
    #   `max_record_bytes`
    #: () { (untyped row) -> void } -> Document
    #: () -> Enumerator[untyped, Document]
    def each_jsonl
      return enum_for(:each_jsonl) unless block_given?

      each_row("jsonl") { |record| yield JSON.parse(record, **JSON_OPTIONS) }
    end

    # Yields each row of a tab-separated document, such as a report, as Strings of UTF-8
    #
    # The first row holds the column names. Text is decoded from the charset of the document's Content-Type. Give
    # `charset:` to decode from another, when Amazon labels the document wrongly. Without a block it returns an
    # Enumerator.
    #
    # @raise [Peddler::DocumentTimeoutError] if the download runs past its timeout
    # @raise [Peddler::DocumentError] if the transfer breaks, the charset is unknown, the text is not in it or a
    #   row is larger than `max_record_bytes`
    #: (?charset: String?) { (Array[String] row) -> void } -> Document
    #: (?charset: String?) -> Enumerator[Array[String], Document]
    def each_tsv(charset: nil, &block)
      return enum_for(:each_tsv, charset: charset) unless block

      each_row("tsv", charset, &block)
    end

    # The whole document as JSON, parsed. A number with a fraction parses as a BigDecimal.
    #
    # @rbs max_bytes: Integer -- the most the document may hold, since all of it is kept in memory
    # @rbs return: untyped
    # @raise [Peddler::DocumentTimeoutError] if the download runs past its timeout
    # @raise [Peddler::DocumentError] if the transfer breaks, the document is larger than `max_bytes` or it is
    #   not JSON
    def json(max_bytes:)
      JSON.parse(@handle.json(Native::TransferConfig.limit(:max_bytes, max_bytes)), **JSON_OPTIONS)
    ensure
      close
    end

    private

    # Yields each row, then closes the document, also when the arguments are invalid or the block breaks or raises
    #: (String mode, ?String? charset) { (untyped row) -> void } -> self
    def each_row(mode, charset = nil)
      raise ArgumentError, "charset must be a UTF-8 String" unless charset.nil? || Native.valid_utf8_string?(charset)

      while (row = @handle.next_row(mode, charset))
        yield row
      end
      self
    ensure
      close
    end
  end

  class Client
    # Opens the document at a signed URL, to read it as it arrives
    #
    # The request carries no access token. A document is decompressed when the reply says
    # `Content-Encoding: gzip`, or when `compression: :gzip` is given.
    #
    # It takes the signed URL and options: `timeout:` in seconds for the whole download (30), `compression:` (`:auto`
    # or `:gzip`), `max_bytes:` for the document once decompressed and `max_record_bytes:` for one row (1 MiB).
    # Without a block it returns the document. With one it yields the document, closes it when the block returns,
    # and returns what the block returned.
    #
    # @example
    #   client.download_document(url, timeout: 120) do |document|
    #     document.each_tsv { |row| puts row.first }
    #   end
    # @raise [ArgumentError] if the URL or an option breaks its rule. The message names it.
    # @raise [Peddler::Error] if the URL answers outside 2xx
    # @raise [Peddler::DocumentTimeoutError] if the download runs past its timeout
    # @raise [Peddler::DocumentError] if the request can't be sent
    #: [T] (String url, **untyped transfer_options) { (Document document) -> T } -> T
    #: (String url, **untyped transfer_options) -> Document
    def download_document(url, **transfer_options, &block)
      raise ArgumentError, "invalid document URL" unless Native.valid_utf8_string?(url)

      Native.open_document(@engine.download_document(url, Native::TransferConfig.json(transfer_options)), &block)
    end

    # Uploads a String or a `read(length)` source to a signed URL
    #
    # The request carries no access token. A String, and a source that answers `size`, as a File and a StringIO
    # do, are sent with their length. Give `content_length:` for another source whose length you know. Without one
    # the body goes out chunked.
    #
    # @example
    #   File.open("feed.json", "rb") do |file|
    #     client.upload_document(url, file, content_type: "application/json; charset=UTF-8")
    #   end
    # @rbs url: String -- the signed URL
    # @rbs source: String | (_DocumentIO & Object) -- the content, or what returns it from `read(length)`
    # @rbs content_type: String -- the content type the URL was signed for
    # @rbs headers: Hash[String, String] -- more headers the URL was signed with
    # @rbs content_length: Integer? -- the bytes the source holds
    # @rbs **transfer_options: untyped -- `timeout:` in seconds for the whole upload (30) and `max_bytes:` for what
    #   is sent
    # @rbs return: Response
    # @raise [ArgumentError] if an argument or an option breaks its rule. The message names it.
    # @raise [Peddler::Error] if the URL answers outside 2xx
    # @raise [Peddler::DocumentTimeoutError] if the upload runs past its timeout
    # @raise [Peddler::DocumentError] if the upload can't be sent, the source fails or its length is not the one
    #   declared
    def upload_document(url, source, content_type:, headers: {}, content_length: nil, **transfer_options)
      Native::Uploads.put(@engine, url, source, content_type, headers, content_length, transfer_options)
    end
  end
end
