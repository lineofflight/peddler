# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about a single product within an order.
      OrderItem = Structure.new do
        # @return [String] A unique identifier for this specific item within the order.
        attribute(:order_item_id, String, from: "orderItemId")

        # @return [ItemProduct] Information about the product being ordered.
        attribute(:product, ItemProduct)

        # @return [Integer] The number of units of this item that the customer ordered.
        attribute(:quantity_ordered, Integer, from: "quantityOrdered")

        # @return [ItemCancellation] The cancellation information of the order item.
        attribute?(:cancellation, ItemCancellation)

        # @return [ItemExpense] The expense information related to this specific item.
        attribute?(:expense, ItemExpense)

        # @return [ItemFulfillment] Information about how the order item should be processed, packed, and shipped to the
        #   customer.
        attribute?(:fulfillment, ItemFulfillment)

        # @return [Measurement] The unit of measure and value for items sold by weight, volume, or other measurements
        #   rather than simple count.
        attribute?(:measurement, Measurement)

        # @return [ItemProceeds] The money that the seller receives from the sale of this specific item.
        attribute?(:proceeds, ItemProceeds)

        # @return [Array<String>] Special programs that apply specifically to this item within the order.
        #
        # **Possible values**: `TRANSPARENCY`, `SUBSCRIBE_AND_SAVE`
        attribute?(:programs, [String])

        # @return [ItemPromotion] Details about any discounts, coupons, or promotional offers applied to this item.
        attribute?(:promotion, ItemPromotion)
      end
    end
  end
end
