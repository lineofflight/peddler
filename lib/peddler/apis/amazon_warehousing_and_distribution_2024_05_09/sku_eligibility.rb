# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents eligibility of one SKU.
      SKUEligibility = Structure.new do
        # @return [DistributionPackageQuantity]
        attribute(:package_quantity, DistributionPackageQuantity, null: false, from: "packageQuantity")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [Array<SkuIneligibilityReason>] If not eligible, these are list of error codes and descriptions.
        attribute?(:ineligibility_reasons, [SKUIneligibilityReason], from: "ineligibilityReasons")
      end
    end
  end
end
