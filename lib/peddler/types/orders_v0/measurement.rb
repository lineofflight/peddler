# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Measurement information for an order item.
      Measurement = Structure.new do
        # @return [String] The unit of measure.
        attribute(:unit, String, from: "Unit")

        # @return [Float] The measurement value.
        attribute(:value, Float, from: "Value")
      end
    end
  end
end
