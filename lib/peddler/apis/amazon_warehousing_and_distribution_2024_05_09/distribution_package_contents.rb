# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents the contents inside a package, which can be products or a nested package.
      DistributionPackageContents = Structure.new do
        # This is required only when `DistributionPackageType=PALLET`.
        attribute?(:packages, [DistributionPackageQuantity])

        # This is required only when `DistributionPackageType=CASE`.
        attribute?(:products, [ProductQuantity])
      end
    end
  end
end
