# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/fee_component"
require "peddler/types/finances_v0/charge_component"
require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A fee payment event for the Early Reviewer Program.
      SellerReviewEnrollmentPaymentEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] An enrollment identifier.
        attribute(:enrollment_id, String, from: "EnrollmentId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item that was enrolled in the Early
        # Reviewer Program.
        attribute(:parent_asin, String, from: "ParentASIN")

        # @return [FeeComponent]
        attribute(:fee_component, FeeComponent, from: "FeeComponent")

        # @return [ChargeComponent]
        attribute(:charge_component, ChargeComponent, from: "ChargeComponent")

        # @return [Currency] The FeeComponent value plus the ChargeComponent value.
        attribute(:total_amount, Currency, from: "TotalAmount")
      end
    end
  end
end
