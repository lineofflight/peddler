# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/box_update_input"
require "peddler/types/fulfillment_inbound_2024_03_20/item_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Objects that were included in the update request.
      RequestedUpdates = Structure.new do
        # @return [Array<BoxUpdateInput>] A list of boxes that will be present in the shipment after the update.
        attribute(:boxes, [BoxUpdateInput])

        # @return [Array<ItemInput>] A list of all items that will be present in the shipment after the update.
        attribute(:items, [ItemInput])
      end
    end
  end
end
