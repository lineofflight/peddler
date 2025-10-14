# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV1
      # An event of a shipment
      Event = Structure.new do
        # @return [String]
        attribute(:event_code, String, from: "eventCode")

        # @return [Time] The date and time of an event for a shipment.
        attribute(:event_time, Time, from: "eventTime")

        # @return [Location]
        attribute?(:location, Location)
      end
    end
  end
end
