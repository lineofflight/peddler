# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Information about the prescription that is used to verify a regulated product. This must be provided once per
      # order and reflect the seller’s own records. Only approved orders can have prescriptions.
      PrescriptionDetail = Structure.new do
        # @return [String] The identifier for the prescription used to verify the regulated product.
        attribute(:prescription_id, String, from: "prescriptionId")

        # @return [String] The expiration date of the prescription used to verify the regulated product, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:expiration_date, String, from: "expirationDate")

        # @return [Integer] The number of units in each fill as provided in the prescription.
        attribute(:written_quantity, Integer, from: "writtenQuantity")

        # @return [Integer] The total number of refills written in the original prescription used to verify the
        # regulated product. If a prescription originally had no refills, this value must be 0.
        attribute(:total_refills_authorized, Integer, from: "totalRefillsAuthorized")

        # @return [Integer] The number of refills remaining for the prescription used to verify the regulated product.
        # If a prescription originally had 10 total refills, this value must be `10` for the first order, `9` for the
        # second order, and `0` for the eleventh order. If a prescription originally had no refills, this value must be
        # 0.
        attribute(:refills_remaining, Integer, from: "refillsRemaining")

        # @return [String] The identifier for the clinic which provided the prescription used to verify the regulated
        # product.
        attribute(:clinic_id, String, from: "clinicId")

        # @return [String] The instructions for the prescription as provided by the approver of the regulated product.
        attribute(:usage_instructions, String, from: "usageInstructions")
      end
    end
  end
end
