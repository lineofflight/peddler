# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `updateItemComplianceDetails` request.
      UpdateItemComplianceDetailsRequest = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String, null: false)

        # @return [TaxDetails]
        attribute(:tax_details, TaxDetails, null: false, from: "taxDetails")
      end
    end
  end
end
