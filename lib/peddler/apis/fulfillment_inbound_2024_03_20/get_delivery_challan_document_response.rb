# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `getDeliveryChallanDocumentResponse` response.
      GetDeliveryChallanDocumentResponse = Structure.new do
        # @return [DocumentDownload]
        attribute(:document_download, DocumentDownload, from: "documentDownload")
      end
    end
  end
end
