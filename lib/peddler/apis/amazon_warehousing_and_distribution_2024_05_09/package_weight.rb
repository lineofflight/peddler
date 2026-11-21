# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents the weight of the package with a unit of measurement.
      PackageWeight = Structure.new do
        # Unit of measurement for the package weight. Known values: `POUNDS`, `KILOGRAMS`.
        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")

        # The package weight value.
        attribute(:weight, Float, null: false)
      end
    end
  end
end
