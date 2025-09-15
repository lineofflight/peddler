# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An item in an adjustment to the seller's account.
      AdjustmentItem = Structure.new do
        # @return [String] Represents the number of units in the seller's inventory when the AdustmentType is
        # FBAInventoryReimbursement.
        attribute(:quantity, String, from: "Quantity")

        # @return [Currency] The per unit value of the item.
        attribute(:per_unit_amount, Currency, from: "PerUnitAmount")

        # @return [Currency] The total value of the item.
        attribute(:total_amount, Currency, from: "TotalAmount")

        # @return [String] The seller SKU of the item. The seller SKU is qualified by the seller's seller ID, which is
        # included with every call to the Selling Partner API.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] A unique identifier assigned to products stored in and fulfilled from a fulfillment center.
        attribute(:fn_sku, String, from: "FnSKU")

        # @return [String] A short description of the item.
        attribute(:product_description, String, from: "ProductDescription")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The transaction number that is related to the adjustment.
        attribute(:transaction_number, String, from: "TransactionNumber")
      end
    end
  end
end
