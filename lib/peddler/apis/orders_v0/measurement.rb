# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Measurement information for an order item.
      Measurement = Structure.new do
        # @return [String] The unit of measure.
        attribute(:unit, String, null: false, from: "Unit")

        # @return [Float] The measurement value.
        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
