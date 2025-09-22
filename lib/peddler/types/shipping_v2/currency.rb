# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The monetary value in the currency indicated, in ISO 4217 standard format.
      Currency = Structure.new do
        # @return [Float] The monetary value.
        attribute(:value, Float)

        # @return [String] The ISO 4217 format 3-character currency code.
        attribute(:unit, String)
      end
    end
  end
end
