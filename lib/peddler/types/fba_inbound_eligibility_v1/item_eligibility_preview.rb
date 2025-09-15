# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FBAInboundEligibilityV1
      # The response object which contains the ASIN, marketplaceId if required, eligibility program, the eligibility
      # status (boolean), and a list of ineligibility reason codes.
      ItemEligibilityPreview = Structure.new do
        # @return [String] The ASIN for which eligibility was determined.
        attribute(:asin, String)

        # @return [String] The marketplace for which eligibility was determined.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The program for which eligibility was determined.
        attribute(:program, String)

        # @return [:boolean] Indicates if the item is eligible for the program.
        attribute(:eligible_for_program, :boolean, from: "isEligibleForProgram")

        # @return [Array<String>] Potential Ineligibility Reason Codes.
        attribute(:ineligibility_reason_list, [String], from: "ineligibilityReasonList")
      end
    end
  end
end
