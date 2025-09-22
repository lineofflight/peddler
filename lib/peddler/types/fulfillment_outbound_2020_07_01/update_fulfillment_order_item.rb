# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Item information for updating a fulfillment order.
      UpdateFulfillmentOrderItem = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [String] Identifies the fulfillment order item to update. Created with a previous call to the
        # `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] A message to the gift recipient, if applicable.
        attribute(:gift_message, String, from: "giftMessage")

        # @return [String] Item-specific text that displays in recipient-facing materials such as the outbound shipment
        # packing slip.
        attribute(:displayable_comment, String, from: "displayableComment")

        # @return [String] Amazon's fulfillment network SKU of the item.
        attribute(:fulfillment_network_sku, String, from: "fulfillmentNetworkSku")

        # @return [String] Indicates whether the item is sellable or unsellable.
        attribute(:order_item_disposition, String, from: "orderItemDisposition")

        # @return [Types::Money] The monetary value assigned by the seller to this item. This is a required field for
        # India MCF orders.
        attribute(:per_unit_declared_value, Types::Money, from: "perUnitDeclaredValue")

        # @return [Types::Money] The amount to be collected from the recipient for this item in a COD (Cash On Delivery)
        # order.
        attribute(:per_unit_price, Types::Money, from: "perUnitPrice")

        # @return [Types::Money] The tax on the amount to be collected from the recipient for this item in a COD (Cash
        # On Delivery) order.
        attribute(:per_unit_tax, Types::Money, from: "perUnitTax")
      end
    end
  end
end
