# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInboundEligibilityV1
      # The response object which contains the ASIN, marketplaceId if required, eligibility program, the eligibility
      # status (boolean), and a list of ineligibility reason codes.
      ItemEligibilityPreview = Structure.new do
        # @return [String] The ASIN for which eligibility was determined.
        attribute(:asin, String, null: false)

        # @return [:boolean] Indicates if the item is eligible for the program.
        attribute(:eligible_for_program, :boolean, null: false, from: "isEligibleForProgram")

        # @return [String] The program for which eligibility was determined.
        attribute(:program, String, null: false)

        # @return [Array<String>] Potential Ineligibility Reason Codes.
        attribute?(:ineligibility_reason_list, [String], from: "ineligibilityReasonList")

        # @return [String] The marketplace for which eligibility was determined.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
