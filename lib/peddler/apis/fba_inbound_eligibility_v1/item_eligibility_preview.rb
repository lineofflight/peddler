# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FBAInboundEligibilityV1
      # The response object which contains the ASIN, marketplaceId if required, eligibility program, the eligibility
      # status (boolean), and a list of ineligibility reason codes.
      ItemEligibilityPreview = Structure.new do
        # The ASIN for which eligibility was determined.
        attribute(:asin, String, null: false)

        # Indicates if the item is eligible for the program.
        attribute(:eligible_for_program, :boolean, null: false, from: "isEligibleForProgram")

        # The program for which eligibility was determined.
        attribute(:program, String, null: false)

        # Potential Ineligibility Reason Codes.
        attribute?(:ineligibility_reason_list, [String], from: "ineligibilityReasonList")

        # The marketplace for which eligibility was determined.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
