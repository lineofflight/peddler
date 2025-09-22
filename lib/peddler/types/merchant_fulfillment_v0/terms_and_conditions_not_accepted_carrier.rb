# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A carrier whose terms and conditions have not been accepted by the seller.
      TermsAndConditionsNotAcceptedCarrier = Structure.new do
        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, from: "CarrierName")
      end
    end
  end
end
