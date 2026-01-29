# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Object containing the documentId and a S3 pre-signed URL to download the specified document file.
      InvoiceDocument = Structure.new do
        # @return [String] A pre-signed URL to download the invoice document in its original format. This URL expires
        #   after 30 seconds.
        attribute?(:invoice_document_url, String, from: "invoiceDocumentUrl")
      end
    end
  end
end
