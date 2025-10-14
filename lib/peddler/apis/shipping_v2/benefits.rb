# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Benefits that are included and excluded for each shipping offer. Benefits represents services provided by Amazon
      # (eg. CLAIMS_PROTECTED, etc.) when sellers purchase shipping through Amazon. Benefit details will be made
      # available for any shipment placed on or after January 1st 2024 00:00 UTC.
      Benefits = Structure.new do
        # @return [Array<ExcludedBenefit>]
        attribute(:excluded_benefits, [ExcludedBenefit], from: "excludedBenefits")

        # @return [Array<String>]
        attribute(:included_benefits, [String], from: "includedBenefits")
      end
    end
  end
end
