# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/location"

module Peddler
  module Types
    module ShippingV2
      # A tracking event.
      Event = Structure.new do
        # @return [String]
        attribute(:event_code, String, from: "eventCode")

        # @return [String] The ISO 8601 formatted timestamp of the event.
        attribute(:event_time, String, from: "eventTime")

        # @return [Location]
        attribute?(:location, Location)

        # @return [String]
        attribute?(:shipment_type, String, from: "shipmentType")
      end
    end
  end
end
