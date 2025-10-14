# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents the volume of the package with a unit of measurement.
      PackageVolume = Structure.new do
        # @return [String] Unit of measurement for the package volume.
        attribute(:unit_of_measurement, String, from: "unitOfMeasurement")

        # @return [Float] The package volume value.
        attribute(:volume, Float)
      end
    end
  end
end
