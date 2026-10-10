# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Package weight and dimension.
      MeasurementData = Structure.new do
        # Weight of the package.
        attribute(:weight, PackageWeight, null: false)

        # Dimensions of the package. Dimensions are required when creating an inbound or outbound order.
        attribute?(:dimensions, PackageDimensions)

        # Volume of the package.
        attribute?(:volume, PackageVolume)
      end
    end
  end
end
