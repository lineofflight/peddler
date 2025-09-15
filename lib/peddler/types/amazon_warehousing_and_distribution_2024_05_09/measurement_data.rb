# frozen_string_literal: true

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/package_dimensions"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/package_volume"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/package_weight"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Package weight and dimension.
      MeasurementData = Structure.new do
        # @return [PackageDimensions] Dimensions of the package. Dimensions are required when creating an inbound or
        # outbound order.
        attribute(:dimensions, PackageDimensions)

        # @return [PackageVolume] Volume of the package.
        attribute(:volume, PackageVolume)

        # @return [PackageWeight] Weight of the package.
        attribute(:weight, PackageWeight)
      end
    end
  end
end
