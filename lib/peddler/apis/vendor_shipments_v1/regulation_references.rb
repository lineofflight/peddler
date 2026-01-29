# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Regulatory requirements and compliance information for the item, including reference numbers, verification
      # codes, and exemption codes. Use this field to specify applicable regulations such as EU Deforestation Regulation
      # (EUDR).
      RegulationReferences = Structure.new do
        # @return [String] The exemption code for EUDR products exempt from due diligence requirements.
        attribute?(:due_diligence_exemption_code, String, from: "dueDiligenceExemptionCode")

        # @return [String] The EUDR Due Diligence information pre-loaded in Vendor Central.
        attribute?(:due_diligence_information, String, from: "dueDiligenceInformation")

        # @return [String] The reference number from the vendor's EUDR Due Diligence Statement (DDS) submitted to the EU
        #   Commission portal or provided to Amazon through ONIX feed.
        attribute?(:due_diligence_reference, String, from: "dueDiligenceReference")

        # @return [String] The EUDR Due Diligence verification number provided by the EU Commission for the submitted
        #   DDS.
        attribute?(:due_diligence_verification, String, from: "dueDiligenceVerification")
      end
    end
  end
end
