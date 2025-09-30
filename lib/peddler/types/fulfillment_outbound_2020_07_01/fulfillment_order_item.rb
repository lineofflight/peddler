# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Item information for a fulfillment order.
      FulfillmentOrderItem = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [String] A fulfillment order item identifier submitted with a call to the `createFulfillmentOrder`
        # operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] A message to the gift recipient, if applicable.
        attribute?(:gift_message, String, from: "giftMessage")

        # @return [String] Item-specific text that displays in recipient-facing materials such as the outbound shipment
        # packing slip.
        attribute?(:displayable_comment, String, from: "displayableComment")

        # @return [String] Amazon's fulfillment network SKU of the item.
        attribute?(:fulfillment_network_sku, String, from: "fulfillmentNetworkSku")

        # @return [String] Indicates whether the item is sellable or unsellable.
        attribute?(:order_item_disposition, String, from: "orderItemDisposition")

        # @return [Integer] The item quantity that was cancelled by the seller.
        attribute(:cancelled_quantity, Integer, from: "cancelledQuantity")

        # @return [Integer] The item quantity that is unfulfillable.
        attribute(:unfulfillable_quantity, Integer, from: "unfulfillableQuantity")

        # @return [String] The estimated date and time that the item quantity is scheduled to ship from the fulfillment
        # center. Note that this value can change over time. If the shipment that contains the item quantity is
        # cancelled, `estimatedShipDate` is not returned.
        attribute?(:estimated_ship_date, String, from: "estimatedShipDate")

        # @return [String] The estimated arrival date and time of the item quantity. Note that this value can change
        # over time. If the shipment that contains the item quantity is cancelled, `estimatedArrivalDate` is not
        # returned.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # @return [Money] The amount to be collected from the recipient for this item in a COD (Cash On Delivery) order.
        attribute?(:per_unit_price, Money, from: "perUnitPrice")

        # @return [Money] The tax on the amount to be collected from the recipient for this item in a COD (Cash On
        # Delivery) order.
        attribute?(:per_unit_tax, Money, from: "perUnitTax")

        # @return [Money] The monetary value assigned by the seller to this item. This is a required field for India MCF
        # orders.
        attribute?(:per_unit_declared_value, Money, from: "perUnitDeclaredValue")
      end
    end
  end
end
