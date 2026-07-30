# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Package information for a shipment in a fulfillment order.
      Package = Structure.new do
        # @return [String] Identifies a package in a shipment.
        attribute(:package_id, String, null: false, from: "packageId")

        # @return [String] The estimated delivery date and time of the package, in ISO 8601 date time format.
        attribute?(:delivery_time, String, from: "deliveryTime")

        # @return [Array<String>] The shipment item identifiers contained in this package.
        attribute?(:shipment_item_ids, [String], from: "shipmentItemIds")

        # @return [String]
        attribute?(:status, String)

        # @return [Tracking] Tracking information for the package.
        attribute?(:tracking, Tracking)
      end
    end
  end
end
