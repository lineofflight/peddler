# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Information about taxes.
      Tax = Structure.new do
        # Details of individual tax charges.
        attribute(:charge, ChargeBreakup, null: false)

        # The rate of the tax.
        attribute?(:rate, String)

        # The type of tax. Known values: `VAT`, `CST`, `IGST`, `SGST`, `CGST`, `UTGST`, `CESS`, `OTHER`, `TOTAL`.
        attribute?(:type, String)
      end
    end
  end
end
