# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DataKiosk20231115
      # The response for the `getDocument` operation.
      GetDocumentResponse = Structure.new do
        # @return [String] The identifier for the Data Kiosk document. This identifier is unique only in combination
        #   with a selling partner account ID.
        attribute(:document_id, String, null: false, from: "documentId")

        # @return [String] A presigned URL that can be used to retrieve the Data Kiosk document. This URL expires after
        #   5 minutes. If the Data Kiosk document is compressed, the `Content-Encoding` header will indicate the
        #   compression algorithm.
        #
        # **Note:** Most HTTP clients are capable of automatically decompressing downloaded files based on the
        #   `Content-Encoding` header.
        attribute(:document_url, String, null: false, from: "documentUrl")
      end
    end
  end
end
