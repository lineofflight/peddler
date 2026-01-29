# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Comprehensive information about a customer order.
      Order = Structure.new do
        # @return [Time] The time when the customer placed the order. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:created_time, Time, from: "createdTime")

        # @return [Time] The most recent time when any aspect of this order was modified by Amazon or the seller. In
        #   [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:last_updated_time, Time, from: "lastUpdatedTime")

        # @return [String] An Amazon-defined order identifier.
        attribute(:order_id, String, from: "orderId")

        # @return [Array<OrderItem>] The list of all order items included in this order.
        attribute(:order_items, [OrderItem], from: "orderItems")

        # @return [SalesChannel] Information about where this order was placed.
        attribute(:sales_channel, SalesChannel, from: "salesChannel")

        # @return [Array<AssociatedOrder>] Other orders that have a direct relationship to this order, such as
        #   replacement or exchange orders.
        attribute?(:associated_orders, [AssociatedOrder], from: "associatedOrders")

        # @return [Buyer] Information about the customer who purchased this order.
        attribute?(:buyer, Buyer)

        # @return [OrderFulfillment] Information about how this order is being processed and shipped.
        attribute?(:fulfillment, OrderFulfillment)

        # @return [Array<Alias>] Alternative identifiers that can be used to reference this order, such as
        #   seller-defined order numbers.
        attribute?(:order_aliases, [Alias], from: "orderAliases")

        # @return [Array<OrderPackage>] Shipping packages created for this order, including tracking information.
        #   **Note:** Only available for merchant-fulfilled (FBM) orders.
        attribute?(:packages, [OrderPackage])

        # @return [OrderProceeds] Financial information about this order.
        attribute?(:proceeds, OrderProceeds)

        # @return [Array<String>] Special programs associated with this order that may affect fulfillment or customer
        #   experience.
        #
        # **Possible values**: `AMAZON_BAZAAR`, `AMAZON_BUSINESS`, `AMAZON_EASY_SHIP`, `AMAZON_HAUL`,
        #   `DELIVERY_BY_AMAZON`, `FBM_SHIP_PLUS`, `IN_STORE_PICK_UP`, `PREMIUM`, `PREORDER`, `PRIME`
        attribute?(:programs, [String])

        # @return [Recipient] Information about the person or location where this order should be delivered.
        attribute?(:recipient, Recipient)
      end
    end
  end
end
