# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents eligibility of one SKU.
      SKUEligibility = Structure.new do
        attribute(:package_quantity, DistributionPackageQuantity, null: false, from: "packageQuantity")

        # Known values: `ELIGIBLE`, `INELIGIBLE`.
        attribute(:status, String, null: false)

        # If not eligible, these are list of error codes and descriptions.
        attribute?(:ineligibility_reasons, [SKUIneligibilityReason], from: "ineligibilityReasons")
      end
    end
  end
end
