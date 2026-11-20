# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # A benefit excluded from a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # The benefit excluded from a shipment.
        attribute?(:benefit, String, from: "Benefit")

        attribute?(:reason_codes, [String], from: "ReasonCodes")
      end
    end
  end
end
