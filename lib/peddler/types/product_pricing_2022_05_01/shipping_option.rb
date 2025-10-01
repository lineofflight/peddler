# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # The shipping option available for the offer.
      ShippingOption = Structure.new do
        # @return [Money] Shipping price for the offer.
        attribute(:price, Money)

        # @return [String] The type of shipping option.
        attribute(:shipping_option_type, String, from: "shippingOptionType")
      end
    end
  end
end
