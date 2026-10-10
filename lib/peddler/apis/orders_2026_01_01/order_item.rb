# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Information about a single product within an order.
      OrderItem = Structure.new do
        # A unique identifier for this specific item within the order.
        attribute(:order_item_id, String, null: false, from: "orderItemId")

        # Information about the product being ordered.
        attribute(:product, ItemProduct, null: false)

        # The number of units of this item that the customer ordered.
        attribute(:quantity_ordered, Integer, null: false, from: "quantityOrdered")

        # A list of order items associated with this item. For example, a value-add service purchased with the product,
        # or a product covered by a warranty protection plan.
        attribute?(:associated_order_items, [AssociatedOrderItem], from: "associatedOrderItems")

        # The cancellation information of the order item.
        attribute?(:cancellation, ItemCancellation)

        # The expense information related to this specific item.
        attribute?(:expense, ItemExpense)

        # Information about how the order item should be processed, packed, and shipped to the customer.
        attribute?(:fulfillment, ItemFulfillment)

        # The unit of measure and value for items sold by weight, volume, or other measurements rather than simple
        # count.
        attribute?(:measurement, Measurement)

        # The money that the seller receives from the sale of this specific item.
        attribute?(:proceeds, ItemProceeds)

        # Special programs that apply specifically to this item within the order.
        #
        # **Possible values**: `TRANSPARENCY`, `SUBSCRIBE_AND_SAVE`
        attribute?(:programs, [String])

        # Details about any discounts, coupons, or promotional offers applied to this item.
        attribute?(:promotion, ItemPromotion)

        # Tax-related information for this order item.
        attribute?(:tax, ItemTax)
      end
    end
  end
end
