# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/sku_ineligibility_reason"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_quantity"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents eligibility of one SKU.
      SkuEligibility = Structure.new do
        # @return [Array<SkuIneligibilityReason>] If not eligible, these are list of error codes and descriptions.
        attribute(:ineligibility_reasons, [SkuIneligibilityReason], from: "ineligibilityReasons")

        # @return [DistributionPackageQuantity]
        attribute(:package_quantity, DistributionPackageQuantity, from: "packageQuantity")

        # @return [String]
        attribute(:status, String)
      end
    end
  end
end
