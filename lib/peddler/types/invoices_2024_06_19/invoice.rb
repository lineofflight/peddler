# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/invoices_2024_06_19/transaction_identifier"

module Peddler
  module Types
    module Invoices20240619
      # Provides detailed information about an invoice.
      Invoice = Structure.new do
        # @return [String] The date and time the invoice is issued. Values are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:date, String)

        # @return [String] If the invoice is in an error state, this attribute displays the error code.
        attribute?(:error_code, String, from: "errorCode")

        # @return [String] The invoice identifier that is used by an external party. This is typically the government
        # agency that authorized the invoice.
        attribute?(:external_invoice_id, String, from: "externalInvoiceId")

        # @return [String] The response message from the government authority when there is an error during invoice
        # issuance.
        attribute?(:gov_response, String, from: "govResponse")

        # @return [String] The invoice identifier.
        attribute?(:id, String)

        # @return [String] The classification of the invoice type. This varies across marketplaces. Use the
        # `getInvoicesAttributes` operation to check `invoiceType` options.
        attribute?(:invoice_type, String, from: "invoiceType")

        # @return [String] Use this identifier in conjunction with `externalInvoiceId` to identify invoices from the
        # same seller.
        attribute?(:series, String)

        # @return [String] The invoice status classification. Use the `getInvoicesAttributes` operation to check invoice
        # status options.
        attribute?(:status, String)

        # @return [Array<TransactionIdentifier>] List with identifiers for the transactions associated to the invoice.
        attribute?(:transaction_ids, [TransactionIdentifier], from: "transactionIds")

        # @return [String] Classification of the transaction that originated this invoice. Use the
        # `getInvoicesAttributes` operation to check `transactionType` options.
        attribute?(:transaction_type, String, from: "transactionType")
      end
    end
  end
end
