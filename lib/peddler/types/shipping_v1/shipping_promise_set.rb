# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/time_range"

module Peddler
  module Types
    module ShippingV1
      # The promised delivery time and pickup time.
      ShippingPromiseSet = Structure.new do
        # @return [TimeRange] The time window in which the shipment will be delivered.
        attribute?(:delivery_window, TimeRange, from: "deliveryWindow")

        # @return [TimeRange] The time window in which Amazon Shipping will pick up the shipment.
        attribute?(:receive_window, TimeRange, from: "receiveWindow")
      end
    end
  end
end
