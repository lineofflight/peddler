# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An expense related to an affordability promotion.
      AffordabilityExpenseEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The date and time when the financial event was created.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] An encrypted, Amazon-defined marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] Indicates the type of transaction.
        #
        # Possible values:
        #
        # * Charge - For an affordability promotion expense.
        #
        # * Refund - For an affordability promotion expense reversal.
        attribute(:transaction_type, String, from: "TransactionType")

        # @return [Currency] The amount charged for clicks incurred under the Sponsored Products program.
        attribute(:base_expense, Currency, from: "BaseExpense")

        # @return [Currency] Central Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_cgst, Currency, from: "TaxTypeCGST")

        # @return [Currency] State Goods and Service Tax, charged and collected by the state government.
        attribute(:tax_type_sgst, Currency, from: "TaxTypeSGST")

        # @return [Currency] Integrated Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_igst, Currency, from: "TaxTypeIGST")

        # @return [Currency] The total amount charged to the seller. TotalExpense = BaseExpense + TaxTypeIGST +
        # TaxTypeCGST + TaxTypeSGST.
        attribute(:total_expense, Currency, from: "TotalExpense")
      end
    end
  end
end
