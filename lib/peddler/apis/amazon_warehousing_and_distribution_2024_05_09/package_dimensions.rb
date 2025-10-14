# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Dimensions of the package.
      PackageDimensions = Structure.new do
        # @return [Float] Height of the package.
        attribute(:height, Float)

        # @return [Float] Length of the package.
        attribute(:length, Float)

        # @return [String] Unit of measurement for package dimensions.
        attribute(:unit_of_measurement, String, from: "unitOfMeasurement")

        # @return [Float] Width of the package.
        attribute(:width, Float)
      end
    end
  end
end
