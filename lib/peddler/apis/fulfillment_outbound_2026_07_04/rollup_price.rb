# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # A component of the total price.
      RollupPrice = Structure.new do
        # @return [String] The type of price.
        attribute(:type, String, null: false)

        # @return [Money] The total value of a price type.
        attribute(:value, Money, null: false)
      end
    end
  end
end
