# frozen_string_literal: true

module Peddler
  module Native
    # The operation each wait polls, by kind, so its response parses to the typed model
    WAIT_OPERATIONS = {
      "report" => "reports_2021_06_30.get_report",
      "feed" => "feeds_2021_06_30.get_feed",
      "query" => "data_kiosk_2023_11_15.get_query",
    }.freeze

    # Seconds v5's document helpers allow for a whole call. They take no options.
    HELPER_TIMEOUT = 600

    class << self
      def valid_identifier?(value)
        valid_utf8_string?(value) && !value.empty?
      end

      # The whole document as a response, decompressed. A URL is downloaded as it is; an ID of the given kind is
      # resolved through the API first. `name` is what the caller's method calls the argument.
      def read_document(engine, kind, name, id_or_url)
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
      def open_workflow_document(engine, kind, document_id, transfer_options, &block)
        id = Arguments.segment("document_id", document_id, last: true)
        open_document(engine.download_workflow_document(kind, id, TransferConfig.json(transfer_options)), &block)
      end

      # The response of the poll that found the job of the given kind finished. `name` is what the caller's method
      # calls the ID.
      def wait_for(engine, kind, name, id, interval, timeout)
        id = Arguments.segment(name, id, last: true)
        raise ArgumentError, "interval must be a positive number of seconds" unless positive_seconds?(interval)

        parts = engine.wait_for(kind, id, interval.to_f, Native.timeout(timeout).to_f)
        Response.from_parts(parts, WAIT_OPERATIONS.fetch(kind))
      end
    end

    # What Peddler adds to the Reports, Feeds and Data Kiosk APIs, beside their operations: v5's document helpers,
    # and what waits for a job and streams or uploads its document.
    #
    # The download_* and upload_* helpers of v5 return the whole body in a response and allow 600 seconds for the
    # whole call. The open_* methods stream instead and take a timeout. Every one raises Peddler::Error when a
    # request is rejected, Peddler::TimeoutError when the request that looks a document up or creates it takes
    # too long, and Peddler::DocumentTimeoutError when the transfer does.

    class Reports20210630
      # Downloads a report by its document ID or URL
      #
      # A report Amazon compresses is decompressed, so the body is the report content. For a report that takes more
      # than 600 seconds, use {#open_report_document} with a `timeout:`.
      #
      # @param [String] report_document_id_or_url the report document identifier or download URL
      # @return [Peddler::Response] the response containing the report content
      def download_report_document(report_document_id_or_url)
        Native.read_document(@engine, "report", "report_document_id_or_url", report_document_id_or_url)
      end

      # Opens a report by its document ID, to read it as it arrives
      #
      # @example
      #   client.reports.open_report_document(report.report_document_id) do |document|
      #     document.each_tsv { |row| puts row.first }
      #   end
      # @param [String] document_id the report document identifier
      # @param [Hash] transfer_options `timeout:` in seconds for the whole download (30), `max_bytes:` for the
      #   document once decompressed and `max_record_bytes:` for one row (1 MiB)
      # @yieldparam [Peddler::Document] document closed when the block returns
      # @return [Peddler::Document, Object] the document, or what the block returns
      # @raise [ArgumentError] if the ID or an option breaks its rule. The message names it.
      def open_report_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "report", document_id, transfer_options, &block)
      end

      # Polls `get_report` until the report is DONE, CANCELLED or FATAL
      #
      # @example
      #   report = client.reports.wait_for_report(report_id).parse
      #   report.processing_status # => "DONE"
      # @param [String] report_id the report identifier
      # @param [Integer, Float] interval seconds between polls
      # @param [Integer, Float] timeout seconds for the whole wait
      # @return [Peddler::Response] the response of the last poll, so check its processing status
      # @raise [Peddler::WorkflowTimeoutError] if the report is still in progress when the timeout ends
      # @raise [Peddler::WorkflowError] if Amazon answers with a status Peddler doesn't know
      # @raise [Peddler::Error] if a poll is rejected
      def wait_for_report(report_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "report", "report_id", report_id, interval, timeout)
      end
    end

    class Feeds20210630
      # Uploads feed content to the signed URL that `create_feed_document` returned
      #
      # For a feed that takes more than 600 seconds, use `client.upload_document(url, source, content_type:, timeout:)`.
      #
      # @param [String] upload_url the signed URL from the `create_feed_document` response
      # @param [String, #read] feed_content the content to upload
      # @param [String] content_type the content type requested in `create_feed_document`
      # @return [Peddler::Response]
      def upload_feed_document(upload_url, feed_content, content_type)
        Uploads.put(@engine, upload_url, feed_content, content_type, {}, nil, { timeout: HELPER_TIMEOUT })
      end

      # Downloads the result of a processed feed from the signed URL that `get_feed_document` returned
      #
      # For a result that takes more than 600 seconds, use {#open_feed_document} with a `timeout:`.
      #
      # @param [String] download_url the signed URL from the `get_feed_document` response
      # @return [Peddler::Response] the response containing the feed result document
      def download_result_feed_document(download_url)
        Native.read_document(@engine, nil, "download_url", download_url)
      end

      # Opens the result of a processed feed by its document ID, to read it as it arrives
      #
      # @param [String] document_id the feed document identifier, such as a feed's `result_feed_document_id`
      # @param [Hash] transfer_options as {Reports20210630#open_report_document} takes them
      # @yieldparam [Peddler::Document] document closed when the block returns
      # @return [Peddler::Document, Object] the document, or what the block returns
      # @raise [ArgumentError] if the ID or an option breaks its rule. The message names it.
      def open_feed_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "feed", document_id, transfer_options, &block)
      end

      # Polls `get_feed` until the feed is DONE, CANCELLED or FATAL
      #
      # @param [String] feed_id the feed identifier
      # @param [Integer, Float] interval seconds between polls
      # @param [Integer, Float] timeout seconds for the whole wait
      # @return [Peddler::Response] the response of the last poll, so check its processing status
      # @raise [Peddler::WorkflowTimeoutError] if the feed is still in progress when the timeout ends
      # @raise [Peddler::WorkflowError] if Amazon answers with a status Peddler doesn't know
      # @raise [Peddler::Error] if a poll is rejected
      def wait_for_feed(feed_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "feed", "feed_id", feed_id, interval, timeout)
      end

      # Creates a feed document and uploads the source to it. Neither request is retried and no feed is created.
      #
      # A String, a File and a StringIO are sent with their length. Give `content_length:` for another source
      # whose length you know. Without one the body goes out chunked.
      #
      # @example
      #   feed_document_id = File.open("feed.json", "rb") do |file|
      #     client.feeds.create_and_upload_feed_document(file, content_type: "application/json; charset=UTF-8")
      #   end
      # @param [String, #read] source the content, or what returns it from `read(length)`
      # @param [String] content_type the content type of the feed, sent to both requests
      # @param [Integer, nil] content_length the bytes the source holds
      # @param [Hash] transfer_options `timeout:` in seconds for both requests (30) and `max_bytes:` for what is sent
      # @return [String] the feed document ID
      # @raise [ArgumentError] if an argument or an option breaks its rule. The message names it.
      # @raise [Peddler::Error] if Amazon rejects the document or its signed URL rejects the upload
      def create_and_upload_feed_document(source, content_type:, content_length: nil, **transfer_options)
        unless Native.valid_identifier?(content_type)
          raise ArgumentError, "content_type must be a UTF-8 String that is not empty"
        end

        Uploads.check(source, content_length)
        upload = @engine.start_feed_document_upload(content_type, TransferConfig.json(transfer_options),
          Uploads.length(source, content_length))
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

    class DataKiosk20231115
      # Downloads a Data Kiosk document by its document ID or URL
      #
      # For a document that takes more than 600 seconds, use {#open_query_document} with a `timeout:`.
      #
      # @param [String] document_id_or_url the document identifier or download URL
      # @return [Peddler::Response] the response containing the document content
      def download_query_document(document_id_or_url)
        Native.read_document(@engine, "query", "document_id_or_url", document_id_or_url)
      end

      # Opens a Data Kiosk document by its ID, to read it as it arrives
      #
      # @example
      #   client.data_kiosk.open_query_document(query.data_document_id) do |document|
      #     document.each_jsonl { |record| puts record }
      #   end
      # @param [String] document_id the document identifier, such as a query's `data_document_id`
      # @param [Hash] transfer_options as {Reports20210630#open_report_document} takes them
      # @yieldparam [Peddler::Document] document closed when the block returns
      # @return [Peddler::Document, Object] the document, or what the block returns
      # @raise [ArgumentError] if the ID or an option breaks its rule. The message names it.
      def open_query_document(document_id, **transfer_options, &block)
        Native.open_workflow_document(@engine, "query", document_id, transfer_options, &block)
      end

      # Polls `get_query` until the query is DONE, CANCELLED or FATAL
      #
      # @param [String] query_id the query identifier
      # @param [Integer, Float] interval seconds between polls
      # @param [Integer, Float] timeout seconds for the whole wait
      # @return [Peddler::Response] the response of the last poll, so check its processing status
      # @raise [Peddler::WorkflowTimeoutError] if the query is still in progress when the timeout ends
      # @raise [Peddler::WorkflowError] if Amazon answers with a status Peddler doesn't know
      # @raise [Peddler::Error] if a poll is rejected
      def wait_for_query(query_id, interval: 5, timeout: 300)
        Native.wait_for(@engine, "query", "query_id", query_id, interval, timeout)
      end
    end
  end
end
