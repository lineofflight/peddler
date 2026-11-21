# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents the volume of the package with a unit of measurement.
      PackageVolume = Structure.new do
        # Unit of measurement for the package volume. Known values: `CU_IN`, `CBM`, `CC`.
        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")

        # The package volume value.
        attribute(:volume, Float, null: false)
      end
    end
  end
end
