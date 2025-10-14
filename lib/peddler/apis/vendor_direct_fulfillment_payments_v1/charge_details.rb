# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentPaymentsV1
      # Monetary and tax details of the charge.
      ChargeDetails = Structure.new do
        # @return [Money]
        attribute(:charge_amount, Money, from: "chargeAmount")

        # @return [String] Type of charge applied.
        attribute(:type, String)

        # @return [Array<TaxDetail>] Individual tax details per line item.
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")
      end
    end
  end
end
