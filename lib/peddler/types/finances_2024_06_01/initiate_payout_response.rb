# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240601
      # The response schema for the `initiatePayout` operation.
      InitiatePayoutResponse = Structure.new do
        # @return [String] The financial event group ID for a successfully initiated payout. You can use this ID to
        # track payout information.
        attribute(:payout_reference_id, String, from: "payoutReferenceId")
      end
    end
  end
end
