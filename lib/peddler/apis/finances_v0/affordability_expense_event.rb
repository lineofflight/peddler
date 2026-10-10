# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An expense related to an affordability promotion.
      AffordabilityExpenseEvent = Structure.new do
        # Central Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_cgst, Money, null: false, from: "TaxTypeCGST")

        # Integrated Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_igst, Money, null: false, from: "TaxTypeIGST")

        # State Goods and Service Tax, charged and collected by the state government.
        attribute(:tax_type_sgst, Money, null: false, from: "TaxTypeSGST")

        # An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # The amount charged for clicks incurred under the Sponsored Products program.
        attribute?(:base_expense, Money, from: "BaseExpense")

        # The Amazon-defined marketplace identifier.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        # The date and time when the financial event was created.
        attribute?(:posted_date, String, from: "PostedDate")

        # The total amount charged to the seller. `TotalExpense` = `BaseExpense` + `TaxTypeIGST` + `TaxTypeCGST` +
        # `TaxTypeSGST`.
        attribute?(:total_expense, Money, from: "TotalExpense")

        # The type of transaction.
        #
        # Possible values:
        #
        # * `Charge`: an affordability promotion expense.
        # * `Refund`: an affordability promotion expense reversal.
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
