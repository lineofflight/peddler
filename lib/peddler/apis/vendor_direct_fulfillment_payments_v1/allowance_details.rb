# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentPaymentsV1
      # Monetary and tax details of the allowance.
      AllowanceDetails = Structure.new do
        # @return [Money] Total monetary amount related to this allowance.
        attribute(:allowance_amount, Money, null: false, from: "allowanceAmount")

        # @return [String] Type of the allowance applied.
        attribute(:type, String, null: false)

        # @return [String] Description of the allowance.
        attribute?(:description, String)

        # @return [Array<TaxDetail>] Tax amount details applied on this allowance.
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")
      end
    end
  end
end
