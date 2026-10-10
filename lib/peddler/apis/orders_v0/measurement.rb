# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Measurement information for an order item.
      Measurement = Structure.new do
        # The unit of measure.
        attribute(:unit, String, null: false, from: "Unit")

        # The measurement value.
        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
