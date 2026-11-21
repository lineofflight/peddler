# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Orders20260101
      # Information related to the shipping and delivery process for an order item.
      ItemShipping = Structure.new do
        # Additional information needed for cross-border delivery of this item.
        attribute?(:international_shipping, ItemInternationalShipping, from: "internationalShipping")

        # When this item is expected to be delivered to the customer.
        attribute?(:scheduled_delivery_window, DateTimeRange, from: "scheduledDeliveryWindow")

        # Special shipping requirements and restrictions that apply to this item.
        attribute?(:shipping_constraints, ItemShippingConstraints, from: "shippingConstraints")
      end
    end
  end
end
