# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/document_download"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `getDeliveryChallanDocumentResponse` response.
      GetDeliveryChallanDocumentResponse = Structure.new do
        # @return [DocumentDownload]
        attribute(:document_download, DocumentDownload, from: "documentDownload")
      end
    end
  end
end
