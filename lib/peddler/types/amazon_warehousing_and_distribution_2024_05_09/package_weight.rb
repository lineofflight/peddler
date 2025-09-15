# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
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
