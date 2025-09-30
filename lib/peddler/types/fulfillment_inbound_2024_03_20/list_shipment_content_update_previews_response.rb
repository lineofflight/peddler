# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/content_update_preview"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `ListShipmentContentUpdatePreviews` response.
      ListShipmentContentUpdatePreviewsResponse = Structure.new do
        # @return [Array<ContentUpdatePreview>] A list of content update previews in a shipment.
        attribute(:content_update_previews, [ContentUpdatePreview], from: "contentUpdatePreviews")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
