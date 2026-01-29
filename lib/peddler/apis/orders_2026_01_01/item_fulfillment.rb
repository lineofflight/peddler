# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about how the order item should be processed, packed, and shipped to the customer.
      ItemFulfillment = Structure.new do
        # @return [ItemPacking] Information related to the packaging process for this item.
        attribute?(:packing, ItemPacking)

        # @return [ItemPicking] Information related to the warehouse picking process for this item.
        attribute?(:picking, ItemPicking)

        # @return [Integer] The number of units of this item that have been successfully processed and shipped.
        attribute?(:quantity_fulfilled, Integer, from: "quantityFulfilled")

        # @return [Integer] The number of units of this item that remain to be processed and shipped.
        attribute?(:quantity_unfulfilled, Integer, from: "quantityUnfulfilled")

        # @return [ItemShipping] Information related to the shipping and delivery process for this item.
        attribute?(:shipping, ItemShipping)
      end
    end
  end
end
