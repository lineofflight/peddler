# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A benefit excluded from a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # @return [String] The benefit excluded from a shipment.
        attribute?(:benefit, String, from: "Benefit")

        # @return [Array<String>]
        attribute?(:reason_codes, [String], from: "ReasonCodes")
      end
    end
  end
end
