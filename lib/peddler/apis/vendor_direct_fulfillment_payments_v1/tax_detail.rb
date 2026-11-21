# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # Details of tax amount applied.
      TaxDetail = Structure.new do
        # Total tax amount applied on invoice total or an item total.
        attribute(:tax_amount, Money, null: false, from: "taxAmount")

        # Type of the tax applied. Known values: `CGST`, `SGST`, `CESS`, `UTGST`, `IGST`, `MwSt.`, `PST`, `TVA`, `VAT`,
        # `GST`, `ST`, `Consumption`, `MutuallyDefined`, `DomesticVAT`.
        attribute(:tax_type, String, null: false, from: "taxType")

        # Tax percentage applied. Percentage must be expressed in decimal.
        attribute?(:tax_rate, String, from: "taxRate")

        # This field will contain the invoice amount that is taxable at the rate specified in the tax rate field.
        attribute?(:taxable_amount, Money, from: "taxableAmount")
      end
    end
  end
end
