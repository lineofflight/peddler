# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Dimensions for printing a shipping label.
      LabelDimensions = Structure.new do
        # @return [Float] The length dimension.
        attribute(:length, Float, from: "Length")

        # @return [Float] The width dimension.
        attribute(:width, Float, from: "Width")

        # @return [String] The unit of measurement.
        attribute(:unit, String, from: "Unit")
      end
    end
  end
end
