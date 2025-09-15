# frozen_string_literal: true

require "peddler/types/shipping_v2/location"

module Peddler
  module Types
    module ShippingV2
      # A tracking event.
      Event = Structure.new do
        # @return [String]
        attribute(:event_code, String, from: "eventCode")

        # @return [Location]
        attribute(:location, Location)

        # @return [String] The ISO 8601 formatted timestamp of the event.
        attribute(:event_time, String, from: "eventTime")

        # @return [String]
        attribute(:shipment_type, String, from: "shipmentType")
      end
    end
  end
end
