# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
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
