# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Dimensions for printing a shipping label.
      LabelDimensions = Structure.new do
        # @return [Float] The length dimension.
        attribute(:length, Float, null: false, from: "Length")

        # @return [String] The unit of measurement.
        attribute(:unit, String, null: false, from: "Unit")

        # @return [Float] The width dimension.
        attribute(:width, Float, null: false, from: "Width")
      end
    end
  end
end
