# frozen_string_literal: true

module Peddler
  # Outcome of create_and_upload_feed_document. The upload response may be a rejection.
  class FeedDocumentUpload
    attr_reader :document_id, :response

    def initialize(document_id, response)
      @document_id = document_id
      @response = response
    end

    def inspect = "#<Peddler::FeedDocumentUpload document_id=#{document_id.inspect}>"
  end

  module Native
    # The operation each wait polls, by kind, so its response parses to the typed model
    WAIT_OPERATIONS = {
      "report" => "reports_2021_06_30.get_report",
      "feed" => "feeds_2021_06_30.get_feed",
      "query" => "data_kiosk_2023_11_15.get_query",
    }.freeze

    class << self
      def valid_identifier?(value)
        valid_utf8_string?(value) && !value.empty?
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

    def create_and_upload_feed_document(source, content_type:, content_length: nil, **transfer_options)
      unless Native.valid_identifier?(content_type) && Native::Uploads.valid?(source, content_length)
        raise ArgumentError, "invalid document upload configuration"
      end
      upload = @engine.start_feed_document_upload(content_type, Native::TransferConfig.json(transfer_options), content_length)
      begin
        document_id = upload.document_id || raise(WorkflowError, "feed document unavailable")
        Native::Uploads.drain(upload, source)
        FeedDocumentUpload.new(document_id, Response.from_document_parts(upload.finish))
      rescue DocumentError => error
        error.with_document_id(document_id) if document_id
        raise
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
