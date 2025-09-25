# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ShippingV2
      # The type and amount of a charge applied on a package.
      ChargeComponent = Structure.new do
        # @return [Money]
        attribute(:amount, Money)

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "chargeType")
      end
    end
  end
end
