# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module DataKiosk20231115
      # The response for the `getDocument` operation.
      GetDocumentResponse = Structure.new do
        # @return [String] The identifier for the Data Kiosk document. This identifier is unique only in combination
        # with a selling partner account ID.
        attribute(:document_id, String, from: "documentId")

        # @return [String] A presigned URL that can be used to retrieve the Data Kiosk document. This URL expires after
        # 5 minutes. If the Data Kiosk document is compressed, the `Content-Encoding` header will indicate the
        # compression algorithm.
        #
        # **Note:** Most HTTP clients are capable of automatically decompressing downloaded files based on the
        # `Content-Encoding` header.
        attribute(:document_url, String, from: "documentUrl")
      end
    end
  end
end
