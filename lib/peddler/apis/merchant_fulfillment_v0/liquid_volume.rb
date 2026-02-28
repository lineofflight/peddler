# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Liquid volume.
      LiquidVolume = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit, String, null: false, from: "Unit")

        # @return [Float] The measurement value.
        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
