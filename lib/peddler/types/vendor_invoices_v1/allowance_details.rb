# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/vendor_invoices_v1/tax_details"

module Peddler
  module Types
    module VendorInvoicesV1
      # Monetary and tax details of the allowance.
      AllowanceDetails = Structure.new do
        # @return [String] Type of the allowance applied.
        attribute(:type, String)

        # @return [String] Description of the allowance.
        attribute(:description, String)

        # @return [Types::Money] Total monetary amount related to this allowance.
        attribute(:allowance_amount, Types::Money, from: "allowanceAmount")

        # @return [Array<TaxDetails>] Tax amount details applied on this allowance.
        attribute(:tax_details, [TaxDetails], from: "taxDetails")
      end
    end
  end
end
