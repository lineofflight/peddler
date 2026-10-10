# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Invoices20240619
      # The information required to create the export request.
      ExportInvoicesRequest = Structure.new do
        # The ID of the marketplace from which you want the invoices.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The latest invoice creation date for invoices that you want to include in the response. Dates are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The default is the time of the
        # request.
        attribute?(:date_end, Date, from: "dateEnd")

        # The earliest invoice creation date for invoices that you want to include in the response. Dates are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The default is 24 hours prior
        # to the time of the request.
        attribute?(:date_start, Date, from: "dateStart")

        # The external ID of the invoices you want included in the response.
        attribute?(:external_invoice_id, String, from: "externalInvoiceId")

        attribute?(:file_format, String, from: "fileFormat")

        # The marketplace-specific classification of the invoice type. Use the `getInvoicesAttributes` operation to
        # check `invoiceType` options.
        attribute?(:invoice_type, String, from: "invoiceType")

        # The series number of the invoices you want included in the response.
        attribute?(:series, String)

        # A list of statuses that you can use to filter invoices. Use the `getInvoicesAttributes` operation to check
        # invoice status options.
        #
        # Min count: 1
        attribute?(:statuses, [String])

        attribute?(:transaction_identifier, TransactionIdentifier, from: "transactionIdentifier")

        # The marketplace-specific classification of the transaction type for which the invoice was created. Use the
        # `getInvoicesAttributes` operation to check `transactionType` options
        attribute?(:transaction_type, String, from: "transactionType")

        # The Warehouse code included in the invoice issued on behalf of the vendor. Check the warehouse code under your
        # WarehouseSettings in VendorCentral.
        attribute?(:warehouse_code, String, from: "warehouseCode")
      end
    end
  end
end
