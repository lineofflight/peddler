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

        # @return [String] The marketplace channel.
        attribute(:marketplace_channel, String, null: false, from: "marketplaceChannel")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The shipping type for the sandbox shipment.
        attribute(:shipping_type, String, null: false, from: "shippingType")

        # @return [String] The number of line items in the shipment.
        attribute?(:line_item_count, String, from: "lineItemCount")

        # @return [Array<String>] The order type attributes for the sandbox shipment.
        attribute?(:order_type, [String], from: "orderType")

        # @return [String] The quantity count per line item.
        attribute?(:quantity_count, String, from: "quantityCount")
      end
    end
  end
end
