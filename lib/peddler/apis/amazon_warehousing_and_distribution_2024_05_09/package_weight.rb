# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents the weight of the package with a unit of measurement.
      PackageWeight = Structure.new do
        # @return [String] Unit of measurement for the package weight.
        attribute(:unit_of_measurement, String, from: "unitOfMeasurement")

        # @return [Float] The package weight value.
        attribute(:weight, Float)
      end
    end
  end
end
