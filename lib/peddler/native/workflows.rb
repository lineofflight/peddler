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
      # resolved through the API first.
      def read_document(engine, kind, id_or_url)
        raise ArgumentError, "invalid document identifier" unless valid_identifier?(id_or_url)

        config = TransferConfig.json(timeout: HELPER_TIMEOUT)
        handle = if kind.nil? || id_or_url.start_with?("http")
          engine.download_document(id_or_url, config)
        else
          engine.download_workflow_document(kind, id_or_url, config)
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
    end

    # The document helpers of v5, on the API views that had them. Each returns the whole body in a response,
    # raises Peddler::Error when a request is rejected, and allows 600 seconds for the whole call. The client's
    # open_*_document methods stream instead and take a timeout.

    class Reports20210630
      # Downloads a report by its document ID or URL
      #
      # A report Amazon compresses is decompressed, so the body is the report content. For a report that takes more
      # than 600 seconds, use `client.open_report_document(id, timeout:)`.
      #
      # @param [String] report_document_id_or_url the report document identifier or download URL
      # @return [Peddler::Response] the response containing the report content
      def download_report_document(report_document_id_or_url)
        Native.read_document(@engine, "report", report_document_id_or_url)
      end
    end

    class Feeds20210630
      # Uploads feed content to the signed URL that `create_feed_document` returned
      #
      # For a feed that takes more than 600 seconds, use `client.upload_document(url, source, content_type:, timeout:)`.
      #
      # @param [String] upload_url the signed URL from the `create_feed_document` response
      # @param [String] feed_content the content to upload
      # @param [String] content_type the content type requested in `create_feed_document`
      # @return [Peddler::Response]
      def upload_feed_document(upload_url, feed_content, content_type)
        Uploads.put(@engine, upload_url, feed_content, content_type, {}, nil, { timeout: HELPER_TIMEOUT })
      end

      # Downloads the result of a processed feed from the signed URL that `get_feed_document` returned
      #
      # For a result that takes more than 600 seconds, use `client.open_feed_document(id, timeout:)`.
      #
      # @param [String] download_url the signed URL from the `get_feed_document` response
      # @return [Peddler::Response] the response containing the feed result document
      def download_result_feed_document(download_url)
        Native.read_document(@engine, nil, download_url)
      end
    end

    class DataKiosk20231115
      # Downloads a Data Kiosk document by its document ID or URL
      #
      # For a document that takes more than 600 seconds, use `client.open_query_document(id, timeout:)`.
      #
      # @param [String] document_id_or_url the document identifier or download URL
      # @return [Peddler::Response] the response containing the document content
      def download_query_document(document_id_or_url)
        Native.read_document(@engine, "query", document_id_or_url)
      end
    end
  end

  class Client
    def open_report_document(document_id, **transfer_options, &block)
      workflow_download("report", document_id, transfer_options, &block)
    end

    def open_feed_document(document_id, **transfer_options, &block)
      workflow_download("feed", document_id, transfer_options, &block)
    end

    def open_query_document(document_id, **transfer_options, &block)
      workflow_download("query", document_id, transfer_options, &block)
    end

    def wait_for_report(report_id, interval: 5, timeout: 300)
      workflow_wait("report", report_id, interval, timeout)
    end

    def wait_for_feed(feed_id, interval: 5, timeout: 300)
      workflow_wait("feed", feed_id, interval, timeout)
    end

    def wait_for_query(query_id, interval: 5, timeout: 300)
      workflow_wait("query", query_id, interval, timeout)
    end

    # Creates a feed document and uploads the source to it. Neither request is retried and no feed is created.
    #
    # @return [String] the feed document ID
    # @raise [Peddler::Error] if Amazon rejects the document or its signed URL rejects the upload
    def create_and_upload_feed_document(source, content_type:, content_length: nil, **transfer_options)
      unless Native.valid_identifier?(content_type) && Native::Uploads.valid?(source, content_length)
        raise ArgumentError, "invalid document upload configuration"
      end
      upload = @engine.start_feed_document_upload(content_type, Native::TransferConfig.json(transfer_options),
        Native::Uploads.length(source, content_length))
      begin
        document_id = upload.document_id || raise(WorkflowError, "feed document unavailable")
        Native::Uploads.drain(upload, source)
        upload.finish
        document_id
      ensure
        upload.close
      end
    end

    private

    def workflow_download(kind, document_id, transfer_options, &block)
      raise ArgumentError, "invalid document identifier" unless Native.valid_identifier?(document_id)

      open_document(@engine.download_workflow_document(kind, document_id, Native::TransferConfig.json(transfer_options)), &block)
    end

    def workflow_wait(kind, id, interval, timeout)
      unless Native.valid_identifier?(id) && Native.positive_seconds?(interval) && Native.positive_seconds?(timeout)
        raise ArgumentError, "invalid workflow configuration"
      end

      Response.from_parts(@engine.wait_for(kind, id, interval.to_f, timeout.to_f), Native::WAIT_OPERATIONS.fetch(kind))
    end
  end
end
