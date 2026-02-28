# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Measurement of a package's dimensions.
      Dimensions = Structure.new do
        # @return [Float] The height of a package.
        attribute(:height, Float, null: false)

        # @return [Float] The length of a package.
        attribute(:length, Float, null: false)

        # @return [String]
        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")

        # @return [Float] The width of a package.
        attribute(:width, Float, null: false)
      end
    end
  end
end
