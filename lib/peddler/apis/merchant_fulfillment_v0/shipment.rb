# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The details of a shipment. Includes the shipment status.
      Shipment = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        # @return [String] The date and time the shipment is created.
        attribute(:created_date, String, null: false, from: "CreatedDate")

        # @return [Money] If you specify `DeclaredValue` in a previous call to the `createShipment` operation, then
        #   `Insurance` indicates the shipment insurance amount that the carrier uses. If `DeclaredValue` isn't with a
        #   previous call to the `createShipment` operation, then the shipment is insured for the carrier's minimum
        #   insurance amount, or the combined sale prices that the items are listed for in the shipment.
        attribute(:insurance, Money, null: false, from: "Insurance")

        # @return [Array<Item>]
        attribute(:item_list, [Item], null: false, from: "ItemList")

        # @return [Label] Data for creating a shipping label and dimensions for printing the label. If the shipment is
        #   canceled, an empty label is returned.
        attribute(:label, Label, null: false, from: "Label")

        # @return [PackageDimensions]
        attribute(:package_dimensions, PackageDimensions, null: false, from: "PackageDimensions")

        # @return [Address] The address of the sender.
        attribute(:ship_from_address, Address, null: false, from: "ShipFromAddress")

        # @return [Address] The destination address for the shipment.
        attribute(:ship_to_address, Address, null: false, from: "ShipToAddress")

        # @return [String]
        attribute(:shipment_id, String, null: false, from: "ShipmentId")

        # @return [ShippingService]
        attribute(:shipping_service, ShippingService, null: false, from: "ShippingService")

        # @return [String] The shipment status.
        attribute(:status, String, null: false, from: "Status")

        # @return [Weight] The package weight.
        attribute(:weight, Weight, null: false, from: "Weight")

        # @return [String] The date and time of the last update.
        attribute?(:last_updated_date, String, from: "LastUpdatedDate")

        # @return [String]
        attribute?(:seller_order_id, String, from: "SellerOrderId")

        # @return [String]
        attribute?(:tracking_id, String, from: "TrackingId")
      end
    end
  end
end
