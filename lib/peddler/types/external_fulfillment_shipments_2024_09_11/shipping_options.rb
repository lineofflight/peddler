# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/time_window"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Shipping options for a single package.
      ShippingOptions = Structure.new do
        # @return [String] The shipper type.
        attribute(:ship_by, String, from: "shipBy")

        # @return [String] An identifier for the shipping option.
        attribute(:shipping_option_id, String, from: "shippingOptionId")

        # @return [String] The carrier name for the offering.
        attribute?(:carrier_name, String, from: "carrierName")

        # @return [TimeWindow] The time window during which the package will be picked up.
        attribute?(:pickup_window, TimeWindow, from: "pickupWindow")

        # @return [TimeWindow] A time window to hand over the package to or from Amazon Logistics.
        attribute?(:time_slot, TimeWindow, from: "timeSlot")
      end
    end
  end
end
