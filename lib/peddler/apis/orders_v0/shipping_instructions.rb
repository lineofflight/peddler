# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The shipping-related information of a delivery.
      ShippingInstructions = Structure.new do
        # @return [String] The name of the carrier that delivers the package.
        attribute?(:carrier_code, String, from: "CarrierCode")

        # @return [FulfillmentPlanShippingConstraints] Models constraints around shipping
        attribute?(:shipping_constraints, FulfillmentPlanShippingConstraints, from: "ShippingConstraints")

        # @return [String] The ship method that is used for the order.
        attribute?(:shipping_method, String, from: "ShippingMethod")
      end
    end
  end
end
