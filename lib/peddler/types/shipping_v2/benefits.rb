# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/excluded_benefit"

module Peddler
  module Types
    module ShippingV2
      # Benefits that are included and excluded for each shipping offer. Benefits represents services provided by Amazon
      # (eg. CLAIMS_PROTECTED, etc.) when sellers purchase shipping through Amazon. Benefit details will be made
      # available for any shipment placed on or after January 1st 2024 00:00 UTC.
      Benefits = Structure.new do
        # @return [Array<String>]
        attribute(:included_benefits, [String], from: "includedBenefits")

        # @return [Array<ExcludedBenefit>]
        attribute(:excluded_benefits, [ExcludedBenefit], from: "excludedBenefits")
      end
    end
  end
end
