# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # A tracking event.
      Event = Structure.new do
        attribute(:event_code, String, null: false, from: "eventCode")

        # The ISO 8601 formatted timestamp of the event.
        attribute(:event_time, Time, null: false, from: "eventTime")

        attribute?(:location, Location)

        attribute?(:shipment_type, String, from: "shipmentType")
      end
    end
  end
end
