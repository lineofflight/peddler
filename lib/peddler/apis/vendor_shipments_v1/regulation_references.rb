# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Container for regulatory compliance information, for instance EU Due Diligence Regulation (EUDR) requirements.
      # Includes reference numbers, verification codes, compliance information, and exemption codes necessary for
      # documenting regulatory compliance for shipments.
      RegulationReferences = Structure.new do
        # @return [String] The Due Diligence exemption code for EUDR products indicating the item is exempt from due
        #   diligence requirements.
        attribute?(:due_diligence_exemption_code, String, from: "dueDiligenceExemptionCode")

        # @return [String] The EUDR Due Diligence Information for EUDR that was already pre-loaded in Vendor Central
        #   within Amazon compliance collection experience.
        attribute?(:due_diligence_information, String, from: "dueDiligenceInformation")

        # @return [String] The EUDR Due Diligence Reference number from vendor's upstream Due Dilligence Statement (DDS)
        #   submitted to EU Commison portal or provided to Onix.
        attribute?(:due_diligence_reference, String, from: "dueDiligenceReference")

        # @return [String] The EUDR Due Diligence Verification number provided by EU Commision associated with submitted
        #   DDR.
        attribute?(:due_diligence_verification, String, from: "dueDiligenceVerification")
      end
    end
  end
end
