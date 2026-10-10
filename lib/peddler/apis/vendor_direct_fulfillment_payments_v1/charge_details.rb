# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # Monetary and tax details of the charge.
      ChargeDetails = Structure.new do
        attribute(:charge_amount, Money, null: false, from: "chargeAmount")

        # Type of charge applied.
        attribute(:type, String, null: false)

        # Individual tax details per line item.
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")
      end
    end
  end
end
