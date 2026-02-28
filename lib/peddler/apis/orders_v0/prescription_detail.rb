# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class OrdersV0
      # Information about the prescription that is used to verify a regulated product. This must be provided once per
      # order and reflect the seller’s own records. Only approved orders can have prescriptions.
      PrescriptionDetail = Structure.new do
        # @return [String] The identifier for the clinic which provided the prescription used to verify the regulated
        #   product.
        attribute(:clinic_id, String, null: false, from: "clinicId")

        # @return [Time] The expiration date of the prescription used to verify the regulated product, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:expiration_date, Time, null: false, from: "expirationDate")

        # @return [String] The identifier for the prescription used to verify the regulated product.
        attribute(:prescription_id, String, null: false, from: "prescriptionId")

        # @return [Integer] The number of refills remaining for the prescription used to verify the regulated product.
        #   If a prescription originally had 10 total refills, this value must be `10` for the first order, `9` for the
        #   second order, and `0` for the eleventh order. If a prescription originally had no refills, this value must
        #   be 0.
        attribute(:refills_remaining, Integer, null: false, from: "refillsRemaining")

        # @return [Integer] The total number of refills written in the original prescription used to verify the
        #   regulated product. If a prescription originally had no refills, this value must be 0.
        attribute(:total_refills_authorized, Integer, null: false, from: "totalRefillsAuthorized")

        # @return [String] The instructions for the prescription as provided by the approver of the regulated product.
        attribute(:usage_instructions, String, null: false, from: "usageInstructions")

        # @return [Integer] The number of units in each fill as provided in the prescription.
        attribute(:written_quantity, Integer, null: false, from: "writtenQuantity")
      end
    end
  end
end
