# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/tax_details"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains item identifiers and related tax information.
      ComplianceDetail = Structure.new do
        # @return [String] The Amazon Standard Identification Number, which identifies the detail page identifier.
        attribute(:asin, String)

        # @return [String] The Fulfillment Network SKU, which identifies a real fulfillable item with catalog data and
        # condition.
        attribute(:fnsku, String)

        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String)

        # @return [TaxDetails]
        attribute(:tax_details, TaxDetails, from: "taxDetails")
      end
    end
  end
end
