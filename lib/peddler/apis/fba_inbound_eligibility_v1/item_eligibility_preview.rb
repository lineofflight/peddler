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

        # @return [String] The program for which eligibility was determined. Known values: `INBOUND`, `COMMINGLING`.
        attribute(:program, String, null: false)

        # @return [Array<String>] Potential Ineligibility Reason Codes. Known values: `FBA_INB_0004`, `FBA_INB_0006`,
        #   `FBA_INB_0007`, `FBA_INB_0008`, `FBA_INB_0009`, `FBA_INB_0010`, `FBA_INB_0011`, `FBA_INB_0012`,
        #   `FBA_INB_0013`, `FBA_INB_0014`, `FBA_INB_0015`, `FBA_INB_0016`, `FBA_INB_0017`, `FBA_INB_0018`,
        #   `FBA_INB_0019`, `FBA_INB_0034`, `FBA_INB_0035`, `FBA_INB_0036`, `FBA_INB_0037`, `FBA_INB_0038`,
        #   `FBA_INB_0050`, `FBA_INB_0051`, `FBA_INB_0053`, `FBA_INB_0055`, `FBA_INB_0056`, `FBA_INB_0059`,
        #   `FBA_INB_0065`, `FBA_INB_0066`, `FBA_INB_0067`, `FBA_INB_0068`, `FBA_INB_0095`, `FBA_INB_0097`,
        #   `FBA_INB_0098`, `FBA_INB_0099`, `FBA_INB_0100`, `FBA_INB_0103`, `FBA_INB_0104`, `FBA_INB_0197`,
        #   `FBA_INB_0342`, `FBA_INB_0465`, `UNKNOWN_INB_ERROR_CODE`.
        attribute?(:ineligibility_reason_list, [String], from: "ineligibilityReasonList")

        # @return [String] The marketplace for which eligibility was determined.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
