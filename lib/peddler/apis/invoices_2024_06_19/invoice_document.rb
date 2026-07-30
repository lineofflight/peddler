# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # The `documentId` and an S3 pre-signed URL that you can use to download the specified document file.
      InvoiceDocument = Structure.new do
        # @return [String] A pre-signed URL that you can use to download the invoice document in its original format.
        #   This URL expires after 30 seconds.
        attribute?(:invoice_document_url, String, from: "invoiceDocumentUrl")
      end
    end
  end
end
