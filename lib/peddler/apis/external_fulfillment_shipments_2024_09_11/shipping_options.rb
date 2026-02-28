# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Shipping options for a single package.
      ShippingOptions = Structure.new do
        # @return [String] The shipper type.
        attribute(:ship_by, String, null: false, from: "shipBy")

        # @return [String] An identifier for the shipping option.
        attribute(:shipping_option_id, String, null: false, from: "shippingOptionId")

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
