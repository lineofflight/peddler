# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The request object for creating a sandbox shipment.
      CreateSandboxShipmentRequest = Structure.new do
        # The location identifier for the shipment.
        attribute(:location_id, String, null: false, from: "locationId")

        # The marketplace channel. Known values: `FBA`, `MFN`.
        attribute(:marketplace_channel, String, null: false, from: "marketplaceChannel")

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The shipping type for the sandbox shipment. Known values: `SELF`, `MARKETPLACE`, `THIRD_PARTY_CARRIER`.
        attribute(:shipping_type, String, null: false, from: "shippingType")

        # The number of line items in the shipment. Known values: `SINGLE`, `MULTIPLE`.
        attribute?(:line_item_count, String, from: "lineItemCount")

        # The order type attributes for the sandbox shipment. Known values: `HAZMAT`, `GIFT_WRAP`, `GIFT_MESSAGE`,
        # `MPS`, `SERIAL`, `CROSS_BORDER`, `REPLACEMENT`, `EXCHANGE`, `PHARMA_NON_PRESCRIPTION`, `PHARMA_PRESCRIPTION`.
        attribute?(:order_type, [String], from: "orderType")

        # The quantity count per line item. Known values: `SINGLE`, `MULTIPLE`.
        attribute?(:quantity_count, String, from: "quantityCount")
      end
    end
  end
end
