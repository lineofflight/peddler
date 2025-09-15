# frozen_string_literal: true

require "peddler/money"
require "peddler/types/vendor_direct_fulfillment_payments_v1/tax_detail"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # Monetary and tax details of the charge.
      ChargeDetails = Structure.new do
        # @return [String] Type of charge applied.
        attribute(:type, String)

        # @return [Money]
        attribute(:charge_amount, Money, from: "chargeAmount")

        # @return [Array<TaxDetail>] Individual tax details per line item.
        attribute(:tax_details, [TaxDetail], from: "taxDetails")
      end
    end
  end
end
