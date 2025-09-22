# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/order_ineligibility_reason"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/sku_eligibility"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents the eligibility status of the inbound packages.
      InboundEligibility = Structure.new do
        # @return [Array<OrderIneligibilityReason>] If there are order level eligibility issues, then this list will
        # contain those error codes and descriptions.
        attribute(:ineligibility_reasons, [OrderIneligibilityReason], from: "ineligibilityReasons")

        # @return [Array<SkuEligibility>] Details on SKU eligibility for each inbound package.
        attribute(:packages_to_inbound, [SkuEligibility], from: "packagesToInbound")

        # @return [String] Timestamp when the eligibility check is performed.
        attribute(:previewed_at, String, from: "previewedAt")

        # @return [String]
        attribute(:status, String)
      end
    end
  end
end
