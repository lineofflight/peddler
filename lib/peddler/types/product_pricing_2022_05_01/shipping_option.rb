# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ProductPricing20220501
      # The shipping option available for the offer.
      ShippingOption = Structure.new do
        # @return [String] The type of shipping option.
        attribute(:shipping_option_type, String, from: "shippingOptionType")

        # @return [Types::Money] Shipping price for the offer.
        attribute(:price, Types::Money)
      end
    end
  end
end
