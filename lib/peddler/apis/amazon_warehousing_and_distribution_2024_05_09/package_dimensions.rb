# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Dimensions of the package.
      PackageDimensions = Structure.new do
        # Height of the package.
        attribute(:height, Float, null: false)

        # Length of the package.
        attribute(:length, Float, null: false)

        # Unit of measurement for package dimensions.
        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")

        # Width of the package.
        attribute(:width, Float, null: false)
      end
    end
  end
end
