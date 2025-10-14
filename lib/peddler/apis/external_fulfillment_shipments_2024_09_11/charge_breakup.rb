# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The composition of the charge.
      ChargeBreakup = Structure.new do
        # @return [Amount] The base amount charged.
        attribute(:base_amount, Amount, from: "baseAmount")

        # @return [Amount] The offer or coupon amount.
        attribute(:discount_amount, Amount, from: "discountAmount")

        # @return [Amount] The total amount after discount.
        attribute(:net_amount, Amount, from: "netAmount")
      end
    end
  end
end
