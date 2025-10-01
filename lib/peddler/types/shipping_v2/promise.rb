# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/time_window"

module Peddler
  module Types
    module ShippingV2
      # The time windows promised for pickup and delivery events.
      Promise = Structure.new do
        # @return [TimeWindow]
        attribute?(:delivery_window, TimeWindow, from: "deliveryWindow")

        # @return [TimeWindow]
        attribute?(:pickup_window, TimeWindow, from: "pickupWindow")
      end
    end
  end
end
