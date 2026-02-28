# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # A tracking event.
      Event = Structure.new do
        # @return [String]
        attribute(:event_code, String, null: false, from: "eventCode")

        # @return [Time] The ISO 8601 formatted timestamp of the event.
        attribute(:event_time, Time, null: false, from: "eventTime")

        # @return [Location]
        attribute?(:location, Location)

        # @return [String]
        attribute?(:shipment_type, String, from: "shipmentType")
      end
    end
  end
end
