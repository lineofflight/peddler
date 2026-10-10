# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Invoices20240619
      # An object that contains the `documentId` and an S3 pre-signed URL that you can use to download the specified
      # file.
      InvoicesDocument = Structure.new do
        # The identifier of the export document.
        attribute?(:invoices_document_id, String, from: "invoicesDocumentId")

        # A pre-signed URL that you can use to download the invoices document in zip format. This URL expires after 30
        # seconds.
        attribute?(:invoices_document_url, String, from: "invoicesDocumentUrl")
      end
    end
  end
end
