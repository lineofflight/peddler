# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Item information for a shipment in a fulfillment order.
      ShipmentItem = Structure.new do
        # @return [Amount]
        attribute(:amount, Amount, null: false)

        # @return [String] The fulfillment order item identifier that the seller created and submitted with a call to
        #   the `createOrder` operation.
        attribute(:line_item_id, String, null: false, from: "lineItemId")

        # @return [ProductIdentifier]
        attribute(:product_identifier, ProductIdentifier, null: false, from: "productIdentifier")

        # @return [String] An identifier for the package that contains the item quantity.
        attribute?(:package_id, String, from: "packageId")

        # @return [String] A unique identifier for the shipment item.
        attribute?(:shipment_item_id, String, from: "shipmentItemId")

        # @return [Hash] The manufacturer lot codes of the shipped items.
        attribute?(:unit_identifiers, Hash, from: "unitIdentifiers")
      end
    end
  end
end
