# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/document_download"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `createMarketplaceItemLabels` response.
      CreateMarketplaceItemLabelsResponse = Structure.new do
        # @return [Array<DocumentDownload>] Resources to download the requested document.
        attribute(:document_downloads, [DocumentDownload], from: "documentDownloads")
      end
    end
  end
end
