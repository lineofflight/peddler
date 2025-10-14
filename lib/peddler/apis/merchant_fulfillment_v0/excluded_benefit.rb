# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # An object representing an excluded benefit that is excluded for a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # @return [String] A benefit that is being excluded from a shipment.
        attribute?(:benefit, String, from: "Benefit")

        # @return [Array<String>]
        attribute?(:reason_codes, [String], from: "ReasonCodes")
      end
    end
  end
end
