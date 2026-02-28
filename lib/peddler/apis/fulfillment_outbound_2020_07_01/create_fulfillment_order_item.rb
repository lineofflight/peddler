# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Item information for creating a fulfillment order.
      CreateFulfillmentOrderItem = Structure.new do
        # @return [Integer]
        attribute(:quantity, Integer, null: false)

        # @return [String] A fulfillment order item identifier that the seller creates to track fulfillment order items.
        #   Used to disambiguate multiple fulfillment items that have the same `sellerSku` value. For example, the
        #   seller might assign different `sellerFulfillmentOrderItemId` values to two items in a fulfillment order that
        #   share the same `sellerSku` value but have different `giftMessage` values.
        attribute(:seller_fulfillment_order_item_id, String, null: false, from: "sellerFulfillmentOrderItemId")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, null: false, from: "sellerSku")

        # @return [String] Item-specific text that displays in recipient-facing materials such as the outbound shipment
        #   packing slip.
        attribute?(:displayable_comment, String, from: "displayableComment")

        # @return [String] Amazon's fulfillment network SKU of the item.
        attribute?(:fulfillment_network_sku, String, from: "fulfillmentNetworkSku")

        # @return [String] A message to the gift recipient, if applicable.
        attribute?(:gift_message, String, from: "giftMessage")

        # @return [Money] The monetary value assigned by the seller to this item. This is a required field for India MCF
        #   orders.
        attribute?(:per_unit_declared_value, Money, from: "perUnitDeclaredValue")

        # @return [Money] The amount to be collected from the recipient for this item in a COD (Cash On Delivery) order.
        attribute?(:per_unit_price, Money, from: "perUnitPrice")

        # @return [Money] The tax on the amount to be collected from the recipient for this item in a COD (Cash On
        #   Delivery) order.
        attribute?(:per_unit_tax, Money, from: "perUnitTax")
      end
    end
  end
end
