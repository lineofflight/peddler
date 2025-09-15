# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The total value of all items in the container.
      Currency = Structure.new do
        # @return [Float] The amount of currency.
        attribute(:value, Float)

        # @return [String] A 3-character currency code.
        attribute(:unit, String)
      end
    end
  end
end
