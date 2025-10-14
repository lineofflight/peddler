# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents the contents inside a package, which can be products or a nested package.
      DistributionPackageContents = Structure.new do
        # @return [Array<DistributionPackageQuantity>] This is required only when `DistributionPackageType=PALLET`.
        attribute?(:packages, [DistributionPackageQuantity])

        # @return [Array<ProductQuantity>] This is required only when `DistributionPackageType=CASE`.
        attribute?(:products, [ProductQuantity])
      end
    end
  end
end
