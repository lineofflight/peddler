# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents a distribution package with its respective quantity.
      DistributionPackageQuantity = Structure.new do
        # @return [Integer] Number of cases or pallets with the same package configuration.
        attribute(:count, Integer, null: false)

        # @return [DistributionPackage]
        attribute(:distribution_package, "DistributionPackage", null: false, from: "distributionPackage")
      end
    end
  end
end
