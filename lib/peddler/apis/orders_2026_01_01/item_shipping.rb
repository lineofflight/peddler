# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Information related to the shipping and delivery process for an order item.
      ItemShipping = Structure.new do
        # @return [ItemInternationalShipping] Additional information needed for cross-border delivery of this item.
        attribute?(:international_shipping, ItemInternationalShipping, from: "internationalShipping")

        # @return [DateTimeRange] When this item is expected to be delivered to the customer.
        attribute?(:scheduled_delivery_window, DateTimeRange, from: "scheduledDeliveryWindow")

        # @return [ItemShippingConstraints] Special shipping requirements and restrictions that apply to this item.
        attribute?(:shipping_constraints, ItemShippingConstraints, from: "shippingConstraints")
      end
    end
  end
end
