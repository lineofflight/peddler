# frozen_string_literal: true

require "peddler/money"

module Peddler
  module Types
    module VendorInvoicesV1
      # Details of tax amount applied.
      TaxDetails = Structure.new do
        # @return [String] Type of the tax applied.
        attribute(:tax_type, String, from: "taxType")

        # @return [String] Tax percentage applied. Percentage must be expressed in decimal.
        attribute(:tax_rate, String, from: "taxRate")

        # @return [Money] Total tax amount applied on invoice total or an item total.
        attribute(:tax_amount, Money, from: "taxAmount")

        # @return [Money] The invoice amount that is taxable at the rate specified in the tax rate field.
        attribute(:taxable_amount, Money, from: "taxableAmount")
      end
    end
  end
end
