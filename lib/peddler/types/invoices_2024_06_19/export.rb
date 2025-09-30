# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Invoices20240619
      # Detailed information about the export.
      Export = Structure.new do
        # @return [String] When the export generation fails, this attribute contains a description of the error.
        attribute?(:error_message, String, from: "errorMessage")

        # @return [String] The export identifier.
        attribute?(:export_id, String, from: "exportId")

        # @return [String] The date and time when the export generation finished. Vales are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:generate_export_finished_at, String, from: "generateExportFinishedAt")

        # @return [String] The date and time when the export generation started. Values are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:generate_export_started_at, String, from: "generateExportStartedAt")

        # @return [Array<String>] The identifier for the export documents. To get the information required to retrieve
        # the export document's contents, pass each ID in the `getInvoicesDocument` operation.
        #
        # This list is empty until the status is `DONE`.
        attribute?(:invoices_document_ids, [String], from: "invoicesDocumentIds")

        # @return [String]
        attribute?(:status, String)
      end
    end
  end
end
