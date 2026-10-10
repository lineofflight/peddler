# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # The tax details for the order.
      # _Note:_ Amazon calculates tax on the list price (Amazon retail price).
      TaxDetails = Structure.new do
        attribute(:tax_amount, Money, null: false, from: "taxAmount")

        attribute?(:tax_rate, String, from: "taxRate")

        attribute?(:taxable_amount, Money, from: "taxableAmount")

        # Tax type.
        attribute?(:type, String)
      end
    end
  end
end
