# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the createClaim operation.
      CreateClaimResponse = Structure.new do
        # @return [String]
        attribute(:claim_id, String, from: "claimId")
      end
    end
  end
end
