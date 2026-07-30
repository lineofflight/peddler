# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Amount-based purchase conditions for basket building promotions. Customers must spend a minimum dollar amount.
      AmountThreshold = Structure.new do
        # @return [Money] Minimum spend amount customers must meet.
        attribute(:currency, Money, null: false)

        # @return [String] Indicates how the amount requirement is evaluated. For spend-based conditions, the supported
        #   value is AT_LEAST, meaning the customer must spend at least the specified dollar amount to qualify.
        attribute(:type, String, null: false)
      end
    end
  end
end
