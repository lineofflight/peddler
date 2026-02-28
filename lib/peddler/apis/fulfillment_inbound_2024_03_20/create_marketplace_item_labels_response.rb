# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `createMarketplaceItemLabels` response.
      CreateMarketplaceItemLabelsResponse = Structure.new do
        # @return [Array<DocumentDownload>] Resources to download the requested document.
        attribute(:document_downloads, [DocumentDownload], null: false, from: "documentDownloads")
      end
    end
  end
end
