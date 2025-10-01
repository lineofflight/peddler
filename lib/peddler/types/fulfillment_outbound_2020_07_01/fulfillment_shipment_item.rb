# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Item information for a shipment in a fulfillment order.
      FulfillmentShipmentItem = Structure.new do
        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] The fulfillment order item identifier that the seller created and submitted with a call to
        # the `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [Array<String>] The manufacturer lot codes of the shipped items.
        attribute?(:manufacturer_lot_codes, [String], from: "manufacturerLotCodes")

        # @return [Integer] An identifier for the package that contains the item quantity.
        attribute?(:package_number, Integer, from: "packageNumber")

        # @return [String] The serial number of the shipped item.
        attribute?(:serial_number, String, from: "serialNumber")
      end
    end
  end
end
