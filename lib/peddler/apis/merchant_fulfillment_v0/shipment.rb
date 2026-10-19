# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The details of a shipment. Includes the shipment status.
      Shipment = Structure.new do
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        # The date and time the shipment is created.
        attribute(:created_date, String, null: false, from: "CreatedDate")

        # If you specify `DeclaredValue` in a previous call to the `createShipment` operation, then `Insurance`
        # indicates the shipment insurance amount that the carrier uses. If `DeclaredValue` isn't with a previous call
        # to the `createShipment` operation, then the shipment is insured for the carrier's minimum insurance amount, or
        # the combined sale prices that the items are listed for in the shipment.
        attribute(:insurance, Money, null: false, from: "Insurance")

        attribute(:item_list, [Item], null: false, from: "ItemList")

        # Data for creating a shipping label and dimensions for printing the label. If the shipment is canceled, an
        # empty label is returned.
        attribute(:label, Label, null: false, from: "Label")

        attribute(:package_dimensions, PackageDimensions, null: false, from: "PackageDimensions")

        # The address of the sender.
        attribute(:ship_from_address, Address, null: false, from: "ShipFromAddress")

        # The destination address for the shipment.
        attribute(:ship_to_address, Address, null: false, from: "ShipToAddress")

        attribute(:shipment_id, String, null: false, from: "ShipmentId")

        attribute(:shipping_service, ShippingService, null: false, from: "ShippingService")

        # The shipment status. Known values: `Purchased`, `RefundPending`, `RefundRejected`, `RefundApplied`.
        attribute(:status, String, null: false, from: "Status")

        # The package weight.
        attribute(:weight, Weight, null: false, from: "Weight")

        # The date and time of the last update.
        attribute?(:last_updated_date, String, from: "LastUpdatedDate")

        attribute?(:seller_order_id, String, from: "SellerOrderId")

        attribute?(:tracking_id, String, from: "TrackingId")
      end
    end
  end
end
