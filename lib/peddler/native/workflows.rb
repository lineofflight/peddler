# frozen_string_literal: true

module Peddler
  class DocumentError
    # Set when an upload fails after its feed document was created.
    attr_reader :document_id

    def with_document_id(document_id)
      @document_id = document_id
      self
    end
  end

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
    class << self
      def valid_identifier?(value)
        valid_utf8_string?(value) && !value.empty?
      end

      def positive_seconds?(value)
        (value.is_a?(Integer) || value.is_a?(Float)) && value.finite? && value > 0
      end
    end
  end

  class Client
    def download_report_document(document_id, **transfer_options, &block)
      workflow_download(:download_report_document, document_id, transfer_options, &block)
    end

    def download_feed_document(document_id, **transfer_options, &block)
      workflow_download(:download_feed_document, document_id, transfer_options, &block)
    end

    def download_query_document(document_id, **transfer_options, &block)
      workflow_download(:download_query_document, document_id, transfer_options, &block)
    end

    def wait_for_report(report_id, interval: 5, timeout: 300)
      workflow_wait(:wait_for_report, "reports_2021_06_30.get_report", report_id, interval, timeout)
    end

    def wait_for_feed(feed_id, interval: 5, timeout: 300)
      workflow_wait(:wait_for_feed, "feeds_2021_06_30.get_feed", feed_id, interval, timeout)
    end

    def wait_for_query(query_id, interval: 5, timeout: 300)
      workflow_wait(:wait_for_query, "data_kiosk_2023_11_15.get_query", query_id, interval, timeout)
    end

    def create_and_upload_feed_document(source, content_type:, content_length: nil, **transfer_options)
      unless Native.valid_identifier?(content_type) &&
          (content_length.nil? || (content_length.is_a?(Integer) && content_length >= 0 && content_length <= Native::UINT64_MAX)) &&
          (source.is_a?(String) || source.respond_to?(:read))
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

    def workflow_download(method, document_id, transfer_options)
      raise ArgumentError, "invalid document identifier" unless Native.valid_identifier?(document_id)

      document = Document.new(@engine.public_send(method, document_id, Native::TransferConfig.json(transfer_options)))
      return document unless block_given?

      begin
        yield document
      ensure
        document.close
      end
    end

    def workflow_wait(method, operation, id, interval, timeout)
      unless Native.valid_identifier?(id) && Native.positive_seconds?(interval) && Native.positive_seconds?(timeout)
        raise ArgumentError, "invalid workflow configuration"
      end

      Response.from_parts(@engine.public_send(method, id, interval.to_f, timeout.to_f), operation)
    end
  end
end
