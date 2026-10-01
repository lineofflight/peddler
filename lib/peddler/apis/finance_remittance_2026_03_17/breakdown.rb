# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinanceRemittance20260317
      # A sub-component of a monetary amount.
      Breakdown = Structure.new do
        # @return [Money] The monetary amount of the sub-component.
        attribute(:breakdown_amount, Money, null: false, from: "breakdownAmount")

        # @return [String] The type of sub-component.
        #
        # **Possible values for `totalAmountBreakdown`:**
        #
        # * `InvoiceAmount`: The amount on the invoice.
        # * `TaxAmount`: The tax amount on the invoice.
        #
        # **Possible values for `netAmountPaidBreakdown`:**
        #
        # * `AmountPaid`: The amount paid for the line item in the remittance.
        # * `TermsDiscountTaken`: The discount applied based on vendor payment terms.
        attribute(:breakdown_type, String, null: false, from: "breakdownType")
      end
    end
  end
end
