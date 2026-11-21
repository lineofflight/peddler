# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrders20211228
      # The tax details for the order.
      # _Note:_ Amazon calculates tax on the list price (Amazon retail price).
      TaxDetails = Structure.new do
        attribute(:tax_amount, Money, null: false, from: "taxAmount")

        attribute?(:tax_rate, String, from: "taxRate")

        attribute?(:taxable_amount, Money, from: "taxableAmount")

        # Tax type. Known values: `CONSUMPTION`, `GST`, `MwSt.`, `PST`, `TOTAL`, `TVA`, `VAT`.
        attribute?(:type, String)
      end
    end
  end
end
