# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The response schema for the createClaim operation.
      CreateClaimResponse = Structure.new do
        # @return [String]
        attribute?(:claim_id, String, from: "claimId")
      end
    end
  end
end
