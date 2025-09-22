# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains the type and rate of tax.
      TaxRate = Structure.new do
        # @return [Float] Rate of cess tax.
        attribute(:cess_rate, Float, from: "cessRate")

        # @return [Float] Rate of gst tax.
        attribute(:gst_rate, Float, from: "gstRate")

        # @return [String] Type of tax. Possible values: `CGST`, `SGST`, `IGST`, `TOTAL_TAX`.
        attribute(:tax_type, String, from: "taxType")
      end
    end
  end
end
