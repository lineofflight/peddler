# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # An object representing an excluded benefit that is excluded for a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # @return [String] A benefit that is being excluded from a shipment.
        attribute(:benefit, String, from: "Benefit")

        # @return [Array<String>]
        attribute(:reason_codes, [String], from: "ReasonCodes")
      end
    end
  end
end
