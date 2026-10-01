# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceExportStatusChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The identifier for the export request. This value is returned by the `createInvoicesExport`
        #   operation.
        attribute(:export_id, String, null: false, from: "exportId")

        # @return [String] The identifier for the store where the invoice applies.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The status of the export request. Possible values: REQUESTED - The export has been received.
        #   PROCESSING - The export is being generated. DONE - The export is complete and available for download. ERROR
        #   - The export failed.
        attribute(:status, String, null: false)
      end
    end
  end
end
