# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FinanceRemittance20260317
      # Detailed line item information for a remittance.
      RemittanceItem = Structure.new do
        # A description of the line item.
        attribute?(:description, String)

        # The invoice issue date in ISO 8601 date-time format.
        attribute?(:invoice_issue_date, Time, from: "invoiceIssueDate")

        # The invoice number.
        attribute?(:invoice_number, String, from: "invoiceNumber")

        # The type of invoice.
        attribute?(:invoice_type, String, from: "invoiceType")

        # The net amount paid for the line item.
        attribute?(:net_amount_paid, Money, from: "netAmountPaid")

        # The breakdown of `netAmountPaid` into sub-components.
        #
        # **Possible `breakdownType` values:**
        #
        # * `AmountPaid`: The amount paid for the line item in the remittance.
        # * `TermsDiscountTaken`: The discount applied based on vendor payment terms. For example, early payment terms
        # such as `1% 30, NET 60` allow a percentage discount on the invoice value when payment is made within the
        # specified period.
        attribute?(:net_amount_paid_breakdown, [Breakdown], from: "netAmountPaidBreakdown")

        # The payment terms.
        attribute?(:payment_terms, String, from: "paymentTerms")

        # A list of related business identifiers for the line item.
        attribute?(:related_item_identifiers, [RelatedItemIdentifier], from: "relatedItemIdentifiers")

        # The total amount for the line item.
        attribute?(:total_amount, Money, from: "totalAmount")

        # The breakdown of `totalAmount` into sub-components.
        #
        # **Possible `breakdownType` values:**
        #
        # * `InvoiceAmount`: The amount on the invoice.
        # * `TaxAmount`: The tax amount on the invoice.
        attribute?(:total_amount_breakdown, [Breakdown], from: "totalAmountBreakdown")

        # The amount withheld on the line item.
        attribute?(:withholding_amount, Money, from: "withholdingAmount")
      end
    end
  end
end
