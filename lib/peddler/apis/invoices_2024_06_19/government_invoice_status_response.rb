# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Invoices20240619
      # Success.
      GovernmentInvoiceStatusResponse = Structure.new do
        # The errors that occurred during invoice creation.
        attribute?(:invoice_errors, [InvoiceError], from: "invoiceErrors")

        # The Government Invoice ID of a successfully authorized invoice.
        attribute?(:invoice_external_document_id, String, from: "invoiceExternalDocumentId")

        attribute?(:status, String)
      end
    end
  end
end
