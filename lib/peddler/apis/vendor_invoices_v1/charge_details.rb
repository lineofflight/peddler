# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorInvoicesV1
      # Monetary and tax details of the charge.
      ChargeDetails = Structure.new do
        # @return [Money] Total monetary amount related to this charge.
        attribute(:charge_amount, Money, from: "chargeAmount")

        # @return [String] Type of the charge applied.
        attribute(:type, String)

        # @return [String] Description of the charge.
        attribute?(:description, String)

        # @return [Array<TaxDetails>] Tax amount details applied on this charge.
        attribute?(:tax_details, [TaxDetails], from: "taxDetails")
      end
    end
  end
end
