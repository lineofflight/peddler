# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # The time windows promised for pickup and delivery events.
      Promise = Structure.new do
        attribute?(:delivery_window, TimeWindow, from: "deliveryWindow")

        attribute?(:pickup_window, TimeWindow, from: "pickupWindow")
      end
    end
  end
end
