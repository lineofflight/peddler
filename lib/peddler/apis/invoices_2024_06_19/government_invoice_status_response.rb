# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GovernmentInvoiceStatusResponse = Structure.new do
        # @return [Array<InvoiceError>] The errors that occurred during invoice creation.
        attribute?(:invoice_errors, [InvoiceError], from: "invoiceErrors")

        # @return [String] Government Invoice ID of a successfully authorized invoice.
        attribute?(:invoice_external_document_id, String, from: "invoiceExternalDocumentId")

        # @return [String]
        attribute?(:status, String)
      end
    end
  end
end
