# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/location"

module Peddler
  module Types
    module ShippingV1
      # An event of a shipment
      Event = Structure.new do
        # @return [String]
        attribute(:event_code, String, from: "eventCode")

        # @return [String] The date and time of an event for a shipment.
        attribute(:event_time, String, from: "eventTime")

        # @return [Location]
        attribute?(:location, Location)
      end
    end
  end
end
