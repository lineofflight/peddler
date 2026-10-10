# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Tax information for an order item.
      ItemTax = Structure.new do
        # A list of tax calculation breakdowns for the order item.
        attribute?(:tax_calculation_breakdowns, [ItemTaxCalculationBreakdown], from: "taxCalculationBreakdowns")

        # A list of tax collections for the order item.
        attribute?(:tax_collections, [ItemTaxCollection], from: "taxCollections")
      end
    end
  end
end
