# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ReportProcessingFinished
      # Nested notification data
      ReportProcessingFinishedNotification = Structure.new do
        # The merchant customer identifier or vendor group identifier of the selling partner account on whose behalf the
        # report was submitted.
        attribute(:account_id, String, null: false, from: "accountId")

        # The processing status of the report.
        attribute(:processing_status, String, null: false, from: "processingStatus")

        # The report identifier.
        attribute(:report_id, String, null: false, from: "reportId")

        # The report type.
        attribute(:report_type, String, null: false, from: "reportType")

        # The report document identifier. This identifier is unique only in combination with a seller ID.
        attribute?(:report_document_id, String, from: "reportDocumentId")

        # The merchant customer identifier of the selling partner account on whose behalf the report was submitted. This
        # field will be null when the report was submitted on behalf of a vendor group identifier.
        attribute?(:seller_id, String, from: "sellerId")
      end
    end
  end
end
