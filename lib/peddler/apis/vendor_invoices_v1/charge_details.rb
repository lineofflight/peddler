# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorInvoicesV1
      # Monetary and tax details of the charge.
      ChargeDetails = Structure.new do
        # Total monetary amount related to this charge.
        attribute(:charge_amount, Money, null: false, from: "chargeAmount")

        # Type of the charge applied.
        attribute(:type, String, null: false)

        # Description of the charge.
        attribute?(:description, String)

        # Tax amount details applied on this charge.
        attribute?(:tax_details, [TaxDetails], from: "taxDetails")
      end
    end
  end
end
