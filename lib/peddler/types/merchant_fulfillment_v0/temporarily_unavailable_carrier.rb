# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A carrier who is temporarily unavailable, most likely due to a service outage experienced by the carrier.
      TemporarilyUnavailableCarrier = Structure.new do
        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, from: "CarrierName")
      end
    end
  end
end
