# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `ListShipmentContentUpdatePreviews` response.
      ListShipmentContentUpdatePreviewsResponse = Structure.new do
        # @return [Array<ContentUpdatePreview>] A list of content update previews in a shipment.
        attribute(:content_update_previews, [ContentUpdatePreview], null: false, from: "contentUpdatePreviews")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
