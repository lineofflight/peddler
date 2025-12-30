# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A fee payment event for the Early Reviewer Program.
      SellerReviewEnrollmentPaymentEvent = Structure.new do
        # @return [ChargeComponent]
        attribute?(:charge_component, ChargeComponent, from: "ChargeComponent")

        # @return [String] An enrollment identifier.
        attribute?(:enrollment_id, String, from: "EnrollmentId")

        # @return [FeeComponent]
        attribute?(:fee_component, FeeComponent, from: "FeeComponent")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item that was enrolled in the Early
        #   Reviewer Program.
        attribute?(:parent_asin, String, from: "ParentASIN")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Money] The `FeeComponent` value plus the `ChargeComponent` value.
        attribute?(:total_amount, Money, from: "TotalAmount")
      end
    end
  end
end
