# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The request object for creating a sandbox shipment.
      CreateSandboxShipmentRequest = Structure.new do
        # @return [String] The location identifier for the shipment.
        attribute(:location_id, String, null: false, from: "locationId")

        # @return [String] The marketplace channel. Known values: `FBA`, `MFN`.
        attribute(:marketplace_channel, String, null: false, from: "marketplaceChannel")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The shipping type for the sandbox shipment. Known values: `Self`, `Marketplace`,
        #   `THIRD_PARTY_CARRIER`.
        attribute(:shipping_type, String, null: false, from: "shippingType")

        # @return [String] The number of line items in the shipment. Known values: `SINGLE`, `MULTIPLE`.
        attribute?(:line_item_count, String, from: "lineItemCount")

        # @return [Array<String>] The order type attributes for the sandbox shipment. Known values: `HAZMAT`,
        #   `GIFT_WRAP`, `GIFT_MESSAGE`, `MPS`, `SERIAL`, `CROSS_BORDER`, `REPLACEMENT`, `EXCHANGE`,
        #   `PHARMA_NON_PRESCRIPTION`, `PHARMA_PRESCRIPTION`.
        attribute?(:order_type, [String], from: "orderType")

        # @return [String] The quantity count per line item. Known values: `SINGLE`, `MULTIPLE`.
        attribute?(:quantity_count, String, from: "quantityCount")
      end
    end
  end
end
