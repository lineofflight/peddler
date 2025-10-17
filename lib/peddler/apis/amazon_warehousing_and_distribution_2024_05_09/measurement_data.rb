# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Package weight and dimension.
      MeasurementData = Structure.new do
        # @return [PackageWeight] Weight of the package.
        attribute(:weight, PackageWeight)

        # @return [PackageDimensions] Dimensions of the package. Dimensions are required when creating an inbound or
        #   outbound order.
        attribute?(:dimensions, PackageDimensions)

        # @return [PackageVolume] Volume of the package.
        attribute?(:volume, PackageVolume)
      end
    end
  end
end
