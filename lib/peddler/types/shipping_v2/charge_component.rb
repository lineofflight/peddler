# frozen_string_literal: true

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # The type and amount of a charge applied on a package.
      ChargeComponent = Structure.new do
        # @return [Currency]
        attribute(:amount, Currency)

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "chargeType")
      end
    end
  end
end
