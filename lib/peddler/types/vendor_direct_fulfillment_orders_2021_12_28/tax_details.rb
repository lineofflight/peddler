# frozen_string_literal: true

require "peddler/types/money"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The tax details for the order.
      # _Note:_ Amazon calculates tax on the list price (Amazon retail price).
      TaxDetails = Structure.new do
        # @return [String]
        attribute(:tax_rate, String, from: "taxRate")

        # @return [Types::Money]
        attribute(:tax_amount, Types::Money, from: "taxAmount")

        # @return [Types::Money]
        attribute(:taxable_amount, Types::Money, from: "taxableAmount")

        # @return [String] Tax type.
        attribute(:type, String)
      end
    end
  end
end
