# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The weight.
      Weight = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit, String)

        # @return [Float] The measurement value.
        attribute(:value, Float)
      end
    end
  end
end
