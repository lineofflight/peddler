# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV1
      # An event of a shipment
      Event = Structure.new do
        attribute(:event_code, String, null: false, from: "eventCode")

        # The date and time of an event for a shipment.
        attribute(:event_time, Time, null: false, from: "eventTime")

        attribute?(:location, Location)
      end
    end
  end
end
