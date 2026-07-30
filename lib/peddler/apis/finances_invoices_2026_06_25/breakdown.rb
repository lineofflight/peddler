# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Details about the movement of money. Breakdowns are further categorized into breakdown types, breakdown amounts,
      # and sub-breakdowns.
      Breakdown = Structure.new do
        # @return [Money] The monetary amount of the charge.
        attribute(:breakdown_amount, Money, null: false, from: "breakdownAmount")

        # @return [String] The type of charge.
        #
        # **Possible values for `invoiceAmountBreakdowns`:**
        #
        # * `Total`: Total invoice amount.
        # * `InvoiceAmountWithoutTax`: Invoice amount excluding tax.
        # * `TaxAmount`: Tax amount on the invoice.
        # * `MiscCharges`: Miscellaneous charges on the invoice.
        # * `Other`: Other breakdown type.
        #
        # **Possible values for `invoiceSettlementBreakdowns`:**
        #
        # * `AmountPaid`: Amount that has been paid.
        # * `QueuedForPayment`: Amount queued for payment.
        # * `QuickPayDiscount`: Quick pay discount amount.
        # * `QuantityVarianceAmount`: Quantity variance amount.
        # * `PriceVariance`: Price variance amount.
        # * `Other`: Other settlement breakdown type.
        #
        # **Possible values for `totalAmountBreakdown` (line item level):**
        #
        # * `ItemCostWithoutTax`: Line item cost excluding tax.
        # * `ItemTaxAmount`: Tax amount on the line item.
        # * `Other`: Other line item breakdown type.
        attribute(:breakdown_type, String, null: false, from: "breakdownType")

        # @return [Array<self>] A list of breakdowns that detail how the total amount is calculated.
        attribute?(:breakdowns, [:self])
      end
    end
  end
end
