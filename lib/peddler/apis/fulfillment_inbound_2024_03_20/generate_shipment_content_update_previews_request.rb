# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `GenerateShipmentContentUpdatePreviews` request.
      GenerateShipmentContentUpdatePreviewsRequest = Structure.new do
        # @return [Array<BoxUpdateInput>] A list of boxes that will be present in the shipment after the update.
        attribute(:boxes, [BoxUpdateInput])

        # @return [Array<ItemInput>] A list of all items that will be present in the shipment after the update.
        attribute(:items, [ItemInput])
      end
    end
  end
end
