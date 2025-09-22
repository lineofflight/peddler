# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

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

        # @return [Money] The amount charged for clicks incurred under the Sponsored Products program.
        attribute(:base_expense, Money, from: "BaseExpense")

        # @return [Money] Central Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_cgst, Money, from: "TaxTypeCGST")

        # @return [Money] State Goods and Service Tax, charged and collected by the state government.
        attribute(:tax_type_sgst, Money, from: "TaxTypeSGST")

        # @return [Money] Integrated Goods and Service Tax, charged and collected by the central government.
        attribute(:tax_type_igst, Money, from: "TaxTypeIGST")

        # @return [Money] The total amount charged to the seller. TotalExpense = BaseExpense + TaxTypeIGST + TaxTypeCGST
        # + TaxTypeSGST.
        attribute(:total_expense, Money, from: "TotalExpense")
      end
    end
  end
end
