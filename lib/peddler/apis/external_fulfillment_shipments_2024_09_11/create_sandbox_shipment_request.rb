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

        # The marketplace channel.
        attribute(:marketplace_channel, String, null: false, from: "marketplaceChannel")

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The shipping type for the sandbox shipment.
        attribute(:shipping_type, String, null: false, from: "shippingType")

        # The number of line items in the shipment.
        attribute?(:line_item_count, String, from: "lineItemCount")

        # The order type attributes for the sandbox shipment.
        attribute?(:order_type, [String], from: "orderType")

        # The quantity count per line item.
        attribute?(:quantity_count, String, from: "quantityCount")
      end
    end
  end
end
