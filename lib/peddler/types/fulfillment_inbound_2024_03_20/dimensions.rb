# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Measurement of a package's dimensions.
      Dimensions = Structure.new do
        # @return [Float] The height of a package.
        attribute(:height, Float)

        # @return [Float] The length of a package.
        attribute(:length, Float)

        # @return [String]
        attribute(:unit_of_measurement, String, from: "unitOfMeasurement")

        # @return [Float] The width of a package.
        attribute(:width, Float)
      end
    end
  end
end
