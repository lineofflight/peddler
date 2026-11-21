# frozen_string_literal: true

module Peddler
  module Native
    # The operation each wait polls, by kind, so its response parses to the typed model
    WAIT_OPERATIONS = {
      "report" => "reports_2021_06_30.get_report",
      "feed" => "feeds_2021_06_30.get_feed",
      "query" => "data_kiosk_2023_11_15.get_query",
    }.freeze #: Hash[String, String]

    # Seconds v5's document helpers allow for a whole call. They take no options.
    HELPER_TIMEOUT = 600

    #: (untyped value) -> bool
    def self.valid_identifier?(value)
      valid_utf8_string?(value) && !value.empty?
    end

    # The whole document as a response, decompressed. A URL is downloaded as it is; an ID of the given kind is
    # resolved through the API first. `name` is what the caller's method calls the argument.
    #: (Engine engine, String? kind, String name, untyped id_or_url) -> Response
    def self.read_document(engine, kind, name, id_or_url)
      raise ArgumentError, "#{name} must be a UTF-8 String that is not empty" unless valid_identifier?(id_or_url)

      config = TransferConfig.json(timeout: HELPER_TIMEOUT)
      handle = if kind.nil? || id_or_url.start_with?("http")
        engine.download_document(id_or_url, config)
      else
        engine.download_workflow_document(kind, Arguments.segment(name, id_or_url, last: true), config)
      end
      begin
        body = +"".b
        while (chunk = handle.next_row("chunks", nil))
          body << chunk
        end
        Response.new(handle.status, handle.headers, body)
      ensure
        handle.close
      end
    end

    # The document of the given kind, looked up by its ID and opened. An ID ends the path of the request that
    # looks it up, so it is checked as that argument is.
    #: [T] (Engine engine, String kind, untyped document_id, Hash[Symbol, untyped] transfer_options) ?{ (Document document) -> T } -> (T | Document)
    def self.open_workflow_document(engine, kind, document_id, transfer_options, &block)
      id = Arguments.segment("document_id", document_id, last: true)
      open_document(engine.download_workflow_document(kind, id, TransferConfig.json(transfer_options)), &block)
    end

    # The response of the poll that found the job of the given kind finished. `name` is what the caller's method
    # calls the ID.
    #: (Engine engine, String kind, String name, untyped id, untyped interval, untyped timeout) -> Response
    def self.wait_for(engine, kind, name, id, interval, timeout)
      id = Arguments.segment(name, id, last: true)
      raise ArgumentError, "interval must be a positive number of seconds" unless positive_seconds?(interval)

      parts = engine.wait_for(kind, id, interval.to_f, Native.timeout(timeout).to_f)
      Response.from_parts(parts, WAIT_OPERATIONS.fetch(kind))
    end

    # What Peddler adds to the Reports API, beside its operations: v5's document helper, and what waits for a report
    # and streams its document.
    #
    # download_report_document, the helper of v5, returns the whole body in a response and allows 600 seconds for the
    # whole call. open_report_document streams instead and takes a timeout. Both raise Peddler::Error when a request
    # is rejected, Peddler::TimeoutError when the request that looks the document up takes too long, and
    # Peddler::DocumentTimeoutError when the transfer does.
    class Reports20210630
      # Downloads a report by its document ID or URL
      #
      # A report Amazon compresses is decompressed, so the body is the report content. For a report that takes more
      # than 600 seconds, use #open_report_document with a `timeout:`.
      #
      # @rbs report_document_id_or_url: String -- the report document identifier or download URL
      # @rbs return: Response -- the response containing the report content
      def download_report_document(report_document_id_or_url)
        Native.read_document(@engine, "report", "report_document_id_or_url", report_document_id_or_url)
      end

      # Opens a report by its document ID, to read it as it arrives
      #
      # It takes the report document identifier and options: `timeout:` in seconds for the whole download (30),
      # `max_bytes:` for the document once decompressed and `max_record_bytes:` for one row (1 MiB). Without a block
      # it returns the document. With one it yields the document, closes it when the block returns, and returns
      # what the block returned.
      #
      # Example:
      #
      #     client.reports.open_report_document(report.report_document_id) do |document|
      #       document.each_tsv { |row| puts row.first }
      #     end
      #
      # Raises ArgumentError if the ID or an option breaks its rule. The message names it.
      #: [T] (String document_id, **untyped transfer_options) { (Document document) -> T } -> T
      #: (String document_id, **untyped transfer_options) -> Document
      def open_report_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "report", document_id, transfer_options, &block)
      end

      # Polls `get_report` until the report is DONE, CANCELLED or FATAL
      #
      # Example:
      #
      #     report = client.reports.wait_for_report(report_id).parse
      #     report.processing_status # => "DONE"
      #
      # @rbs report_id: String -- the report identifier
      # @rbs interval: Integer | Float -- seconds between polls
      # @rbs timeout: Integer | Float -- seconds for the whole wait
      # @rbs return: Response -- the response of the last poll, so check its processing status
      # Raises Peddler::WorkflowTimeoutError if the report is still in progress when the timeout ends.
      # Raises Peddler::WorkflowError if Amazon answers with a status Peddler doesn't know.
      # Raises Peddler::Error if a poll is rejected.
      def wait_for_report(report_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "report", "report_id", report_id, interval, timeout)
      end
    end

    # What Peddler adds to the Feeds API, beside its operations: v5's document helpers, and what waits for a feed,
    # streams its result and uploads its document.
    #
    # upload_feed_document and download_result_feed_document, the helpers of v5, return the whole body in a response
    # and allow 600 seconds for the whole call. open_feed_document streams instead and takes a timeout. Every one
    # raises Peddler::Error when a request is rejected, Peddler::TimeoutError when the request that looks a document
    # up or creates it takes too long, and Peddler::DocumentTimeoutError when the transfer does.
    class Feeds20210630
      # Uploads feed content to the signed URL that `create_feed_document` returned
      #
      # For a feed that takes more than 600 seconds, use `client.upload_document(url, source, content_type:, timeout:)`.
      #
      # @rbs upload_url: String -- the signed URL from the `create_feed_document` response
      # @rbs feed_content: String | (_DocumentIO & Object) -- the content to upload
      # @rbs content_type: String -- the content type requested in `create_feed_document`
      # @rbs return: Response
      def upload_feed_document(upload_url, feed_content, content_type)
        Uploads.put(@engine, upload_url, feed_content, content_type, {}, nil, { timeout: HELPER_TIMEOUT })
      end

      # Downloads the result of a processed feed from the signed URL that `get_feed_document` returned
      #
      # For a result that takes more than 600 seconds, use #open_feed_document with a `timeout:`.
      #
      # @rbs download_url: String -- the signed URL from the `get_feed_document` response
      # @rbs return: Response -- the response containing the feed result document
      def download_result_feed_document(download_url)
        Native.read_document(@engine, nil, "download_url", download_url)
      end

      # Opens the result of a processed feed by its document ID, to read it as it arrives
      #
      # It takes the feed document identifier, such as a feed's `result_feed_document_id`, and the options
      # Reports20210630#open_report_document takes. Without a block it returns the document. With one it yields
      # the document, closes it when the block returns, and returns what the block returned.
      #
      # Raises ArgumentError if the ID or an option breaks its rule. The message names it.
      #: [T] (String document_id, **untyped transfer_options) { (Document document) -> T } -> T
      #: (String document_id, **untyped transfer_options) -> Document
      def open_feed_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "feed", document_id, transfer_options, &block)
      end

      # Polls `get_feed` until the feed is DONE, CANCELLED or FATAL
      #
      # @rbs feed_id: String -- the feed identifier
      # @rbs interval: Integer | Float -- seconds between polls
      # @rbs timeout: Integer | Float -- seconds for the whole wait
      # @rbs return: Response -- the response of the last poll, so check its processing status
      # Raises Peddler::WorkflowTimeoutError if the feed is still in progress when the timeout ends.
      # Raises Peddler::WorkflowError if Amazon answers with a status Peddler doesn't know.
      # Raises Peddler::Error if a poll is rejected.
      def wait_for_feed(feed_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "feed", "feed_id", feed_id, interval, timeout)
      end

      # Creates a feed document and uploads the source to it. No feed is created. The upload is never retried.
      # Creating the document is retried as the client retries a write: after a 429 only.
      #
      # A String, and a source that answers `size`, as a File and a StringIO do, are sent with their length. Give
      # `content_length:` for another source whose length you know. Without one the body goes out chunked.
      #
      # Example:
      #
      #     feed_document_id = File.open("feed.json", "rb") do |file|
      #       client.feeds.create_and_upload_feed_document(file, content_type: "application/json; charset=UTF-8")
      #     end
      #
      # @rbs source: String | (_DocumentIO & Object) -- the content, or what returns it from `read(length)`
      # @rbs content_type: String -- the content type of the feed, sent to both requests
      # @rbs content_length: Integer? -- the bytes the source holds
      # @rbs **transfer_options: untyped -- `timeout:` in seconds for both requests (30) and `max_bytes:` for what is
      #   sent
      # @rbs return: String -- the feed document ID
      # Raises ArgumentError if an argument or an option breaks its rule. The message names it.
      # Raises Peddler::Error if Amazon rejects the document or its signed URL rejects the upload.
      # Raises Peddler::DocumentError if the source is larger than `max_bytes:`, before a document is created.
      def create_and_upload_feed_document(source, content_type:, content_length: nil, **transfer_options)
        unless Native.valid_identifier?(content_type)
          raise ArgumentError, "content_type must be a UTF-8 String that is not empty"
        end

        Uploads.check(source, content_length)
        upload = @engine.start_feed_document_upload(content_type, TransferConfig.json(transfer_options),
          Uploads.length(source, content_length), !content_length.nil?)
        begin
          document_id = upload.document_id || raise(WorkflowError, "feed document unavailable")
          Uploads.drain(upload, source)
          upload.finish
          document_id
        ensure
          upload.close
        end
      end
    end

    # What Peddler adds to the Data Kiosk API, beside its operations: v5's document helper, and what waits for a
    # query and streams its document.
    #
    # download_query_document, the helper of v5, returns the whole body in a response and allows 600 seconds for the
    # whole call. open_query_document streams instead and takes a timeout. Both raise Peddler::Error when a request
    # is rejected, Peddler::TimeoutError when the request that looks the document up takes too long, and
    # Peddler::DocumentTimeoutError when the transfer does.
    class DataKiosk20231115
      # Downloads a Data Kiosk document by its document ID or URL
      #
      # For a document that takes more than 600 seconds, use #open_query_document with a `timeout:`.
      #
      # @rbs document_id_or_url: String -- the document identifier or download URL
      # @rbs return: Response -- the response containing the document content
      def download_query_document(document_id_or_url)
        Native.read_document(@engine, "query", "document_id_or_url", document_id_or_url)
      end

      # Opens a Data Kiosk document by its ID, to read it as it arrives
      #
      # It takes the document identifier, such as a query's `data_document_id`, and the options
      # Reports20210630#open_report_document takes. Without a block it returns the document. With one it yields
      # the document, closes it when the block returns, and returns what the block returned.
      #
      # Example:
      #
      #     client.data_kiosk.open_query_document(query.data_document_id) do |document|
      #       document.each_jsonl { |record| puts record }
      #     end
      #
      # Raises ArgumentError if the ID or an option breaks its rule. The message names it.
      #: [T] (String document_id, **untyped transfer_options) { (Document document) -> T } -> T
      #: (String document_id, **untyped transfer_options) -> Document
      def open_query_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "query", document_id, transfer_options, &block)
      end

      # Polls `get_query` until the query is DONE, CANCELLED or FATAL
      #
      # @rbs query_id: String -- the query identifier
      # @rbs interval: Integer | Float -- seconds between polls
      # @rbs timeout: Integer | Float -- seconds for the whole wait
      # @rbs return: Response -- the response of the last poll, so check its processing status
      # Raises Peddler::WorkflowTimeoutError if the query is still in progress when the timeout ends.
      # Raises Peddler::WorkflowError if Amazon answers with a status Peddler doesn't know.
      # Raises Peddler::Error if a poll is rejected.
      def wait_for_query(query_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "query", "query_id", query_id, interval, timeout)
      end
    end
  end
end
