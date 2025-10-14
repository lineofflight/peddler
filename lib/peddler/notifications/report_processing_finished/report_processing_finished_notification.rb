# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ReportProcessingFinished
      # Nested notification data
      ReportProcessingFinishedNotification = Structure.new do
        # @return [String] The merchant customer identifier or vendor group identifier of the selling partner account on
        # whose behalf the report was submitted.
        attribute(:account_id, String, from: "accountId")

        # @return [String] The processing status of the report.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [String] The report identifier.
        attribute(:report_id, String, from: "reportId")

        # @return [String] The report type.
        attribute(:report_type, String, from: "reportType")

        # @return [String] The report document identifier. This identifier is unique only in combination with a seller
        # ID.
        attribute?(:report_document_id, String, from: "reportDocumentId")

        # @return [String] The merchant customer identifier of the selling partner account on whose behalf the report
        # was submitted. This field will be null when the report was submitted on behalf of a vendor group identifier.
        attribute?(:seller_id, String, from: "sellerId")
      end
    end
  end
end
