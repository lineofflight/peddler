# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A carrier whose terms and conditions have not been accepted by the seller.
      TermsAndConditionsNotAcceptedCarrier = Structure.new do
        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, null: false, from: "CarrierName")
      end
    end
  end
end
