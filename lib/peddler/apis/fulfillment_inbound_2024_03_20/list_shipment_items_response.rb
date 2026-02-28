# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listShipmentItems` response.
      ListShipmentItemsResponse = Structure.new do
        # @return [Array<Item>] The items in a shipment.
        attribute(:items, [Item], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
