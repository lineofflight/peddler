# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD distribution package.
      DistributionPackage = Structure.new do
        # The contents appropriate for the type.
        attribute(:contents, DistributionPackageContents, null: false)

        # Measurements of a package, including weight, volume, and dimensions.
        attribute(:measurements, MeasurementData, null: false)

        # Type of distribution package.
        attribute(:type, String, null: false)
      end
    end
  end
end
