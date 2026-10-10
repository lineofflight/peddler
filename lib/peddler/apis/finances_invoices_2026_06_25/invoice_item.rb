# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesInvoices20260625
      # A line item within an invoice, including unit costs, quantities, tax information, and contextual details about
      # the goods or services being invoiced.
      InvoiceItem = Structure.new do
        # Contextual information about the line item.
        attribute(:line_item_context, LineItemContext, null: false, from: "lineItemContext")

        # The unique identifier for the line item.
        attribute(:line_item_id, String, null: false, from: "lineItemId")

        # The total monetary amount for the line item, including tax.
        attribute(:total_amount, Money, null: false, from: "totalAmount")

        # The number of units for the line item.
        attribute?(:quantity, Integer)

        # List of related item identifiers for the line item.
        attribute?(:related_item_identifiers, [RelatedIdentifier], from: "relatedItemIdentifiers")

        # A list of country code and tax rate combinations applied to the line item. Example: `DE 19`
        attribute?(:tax_rate_codes, [String], from: "taxRateCodes")

        # The breakdown of the total amount into sub-components.
        #
        # **Possible `breakdownType` values:**
        #
        # * `ItemCostWithoutTax`: Line item cost excluding tax.
        # * `ItemTaxAmount`: Tax amount on the line item.
        # * `Other`: Other line item breakdown type.
        attribute?(:total_amount_breakdown, [Breakdown], from: "totalAmountBreakdown")

        # The cost per unit of the line item.
        attribute?(:unit_cost, Money, from: "unitCost")
      end
    end
  end
end
