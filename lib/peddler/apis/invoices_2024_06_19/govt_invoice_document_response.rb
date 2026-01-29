# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GovtInvoiceDocumentResponse = Structure.new do
        # @return [InvoiceDocument]
        attribute?(:invoice_document, InvoiceDocument, from: "invoiceDocument")
      end
    end
  end
end
