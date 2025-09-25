# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents a distribution package with its respective quantity.
      DistributionPackageQuantity = Structure.new do
        # @return [Integer] Number of cases or pallets with the same package configuration.
        attribute(:count, Integer)

        # @return [DistributionPackage]
        attribute(:distribution_package, "DistributionPackage", from: "distributionPackage")
      end
    end
  end
end
