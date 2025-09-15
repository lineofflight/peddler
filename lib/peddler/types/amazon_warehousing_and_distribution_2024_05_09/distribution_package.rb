# frozen_string_literal: true

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_contents"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/measurement_data"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD distribution package.
      DistributionPackage = Structure.new do
        # @return [DistributionPackageContents] The contents appropriate for the type.
        attribute(:contents, DistributionPackageContents)

        # @return [MeasurementData] Measurements of a package, including weight, volume, and dimensions.
        attribute(:measurements, MeasurementData)

        # @return [String] Type of distribution package.
        attribute(:type, String)
      end
    end
  end
end
