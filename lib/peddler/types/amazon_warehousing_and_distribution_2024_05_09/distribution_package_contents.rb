# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_quantity"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/product_quantity"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents the contents inside a package, which can be products or a nested package.
      DistributionPackageContents = Structure.new do
        # @return [Array<DistributionPackageQuantity>] This is required only when `DistributionPackageType=PALLET`.
        attribute(:packages, [DistributionPackageQuantity])

        # @return [Array<ProductQuantity>] This is required only when `DistributionPackageType=CASE`.
        attribute(:products, [ProductQuantity])
      end
    end
  end
end
