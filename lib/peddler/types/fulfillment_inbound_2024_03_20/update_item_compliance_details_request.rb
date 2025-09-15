# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/tax_details"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `updateItemComplianceDetails` request.
      UpdateItemComplianceDetailsRequest = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String)

        # @return [TaxDetails]
        attribute(:tax_details, TaxDetails, from: "taxDetails")
      end
    end
  end
end
