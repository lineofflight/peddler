# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/invoices_2024_06_19/transaction_identifier"

module Peddler
  module Types
    module Invoices20240619
      # The information required to create the export request.
      ExportInvoicesRequest = Structure.new do
        # @return [String] The latest invoice creation date for invoices that you want to include in the response. Dates
        # are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The default is the
        # time of the request.
        attribute?(:date_end, String, from: "dateEnd")

        # @return [String] The earliest invoice creation date for invoices that you want to include in the response.
        # Dates are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The default
        # is 24 hours prior to the time of the request.
        attribute?(:date_start, String, from: "dateStart")

        # @return [String] The external ID of the invoices you want included in the response.
        attribute?(:external_invoice_id, String, from: "externalInvoiceId")

        # @return [String]
        attribute?(:file_format, String, from: "fileFormat")

        # @return [String] The marketplace-specific classification of the invoice type. Use the `getInvoicesAttributes`
        # operation to check `invoiceType` options.
        attribute?(:invoice_type, String, from: "invoiceType")

        # @return [String] The ID of the marketplace from which you want the invoices.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The series number of the invoices you want included in the response.
        attribute?(:series, String)

        # @return [Array<String>] A list of statuses that you can use to filter invoices. Use the
        # `getInvoicesAttributes` operation to check invoice status options.
        #
        # Min count: 1
        attribute?(:statuses, [String])

        # @return [TransactionIdentifier]
        attribute?(:transaction_identifier, TransactionIdentifier, from: "transactionIdentifier")

        # @return [String] The marketplace-specific classification of the transaction type for which the invoice was
        # created. Use the `getInvoicesAttributes` operation to check `transactionType` options
        attribute?(:transaction_type, String, from: "transactionType")
      end
    end
  end
end
