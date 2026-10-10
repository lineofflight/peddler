# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Benefits that are included and excluded for each shipping offer. Benefits represents services provided by Amazon
      # (for example, `CLAIMS_PROTECTED`) when sellers purchase shipping through Amazon. Benefit details are made
      # available for any shipment placed on or after January 1st 2024 00:00 UTC.
      Benefits = Structure.new do
        attribute?(:excluded_benefits, [ExcludedBenefit], from: "ExcludedBenefits")

        attribute?(:included_benefits, [String], from: "IncludedBenefits")
      end
    end
  end
end
