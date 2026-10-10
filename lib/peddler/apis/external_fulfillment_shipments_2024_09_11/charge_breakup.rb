# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The composition of the charge.
      ChargeBreakup = Structure.new do
        # The base amount charged.
        attribute(:base_amount, Amount, null: false, from: "baseAmount")

        # The offer or coupon amount.
        attribute(:discount_amount, Amount, null: false, from: "discountAmount")

        # The total amount after discount.
        attribute(:net_amount, Amount, null: false, from: "netAmount")
      end
    end
  end
end
