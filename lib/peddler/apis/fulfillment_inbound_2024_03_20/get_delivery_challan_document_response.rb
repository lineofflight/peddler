# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `getDeliveryChallanDocumentResponse` response.
      GetDeliveryChallanDocumentResponse = Structure.new do
        attribute(:document_download, DocumentDownload, null: false, from: "documentDownload")
      end
    end
  end
end
