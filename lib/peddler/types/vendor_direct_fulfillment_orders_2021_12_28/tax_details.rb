# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The tax details for the order.
      # _Note:_ Amazon calculates tax on the list price (Amazon retail price).
      TaxDetails = Structure.new do
        # @return [String]
        attribute(:tax_rate, String, from: "taxRate")

        # @return [Money]
        attribute(:tax_amount, Money, from: "taxAmount")

        # @return [Money]
        attribute(:taxable_amount, Money, from: "taxableAmount")

        # @return [String] Tax type.
        attribute(:type, String)
      end
    end
  end
end
