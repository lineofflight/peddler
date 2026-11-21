# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Orders20260101
      # Comprehensive information about a customer order.
      Order = Structure.new do
        # The time when the customer placed the order. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:created_time, Time, null: false, from: "createdTime")

        # The most recent time when any aspect of this order was modified by Amazon or the seller. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:last_updated_time, Time, null: false, from: "lastUpdatedTime")

        # An Amazon-defined order identifier.
        attribute(:order_id, String, null: false, from: "orderId")

        # The list of all order items included in this order.
        attribute(:order_items, [OrderItem], null: false, from: "orderItems")

        # Information about where this order was placed.
        attribute(:sales_channel, SalesChannel, null: false, from: "salesChannel")

        # Other orders that have a direct relationship to this order, such as replacement or exchange orders.
        attribute?(:associated_orders, [AssociatedOrder], from: "associatedOrders")

        # Information about the customer who purchased this order.
        attribute?(:buyer, Buyer)

        # Information about how this order is being processed and shipped.
        attribute?(:fulfillment, OrderFulfillment)

        # The list of fulfillment orders associated with this customer order. Each entry corresponds to one fulfillment
        # unit created by Amazon for this order. **Note:** Only available for Easy Ship and Seller Flex.
        attribute?(:fulfillment_orders, [FulfillmentOrder], from: "fulfillmentOrders")

        # Alternative identifiers that can be used to reference this order, such as seller-defined order numbers.
        attribute?(:order_aliases, [Alias], from: "orderAliases")

        # Shipping packages created for this order, including tracking information. **Note:** Only available for
        # merchant-fulfilled (FBM) orders.
        attribute?(:packages, [OrderPackage])

        # Payment information for the order.
        attribute?(:payment, OrderPayment)

        # Financial information about this order.
        attribute?(:proceeds, OrderProceeds)

        # Special programs associated with this order that may affect fulfillment or customer experience.
        #
        # **Possible values**: `AMAZON_BAZAAR`, `AMAZON_BUSINESS`, `AMAZON_EASY_SHIP`, `AMAZON_HAUL`,
        # `DELIVERY_BY_AMAZON`, `FBM_SHIP_PLUS`, `INVOICE_BY_AMAZON`, `IN_STORE_PICK_UP`, `PREMIUM`, `PREORDER`, `PRIME`
        attribute?(:programs, [String])

        # Information about the person or location where this order should be delivered.
        attribute?(:recipient, Recipient)

        # Tax-related information for the order.
        attribute?(:tax, OrderTax)
      end
    end
  end
end
