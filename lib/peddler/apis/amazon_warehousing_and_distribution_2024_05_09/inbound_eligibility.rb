# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents the eligibility status of the inbound packages.
      InboundEligibility = Structure.new do
        # @return [Array<SkuEligibility>] Details on SKU eligibility for each inbound package.
        attribute(:packages_to_inbound, [SKUEligibility], null: false, from: "packagesToInbound")

        # @return [Time] Timestamp when the eligibility check is performed.
        attribute(:previewed_at, Time, null: false, from: "previewedAt")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [Array<OrderIneligibilityReason>] If there are order level eligibility issues, then this list will
        #   contain those error codes and descriptions.
        attribute?(:ineligibility_reasons, [OrderIneligibilityReason], from: "ineligibilityReasons")
      end
    end
  end
end
