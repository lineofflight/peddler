# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains item identifiers and related tax information.
      ComplianceDetail = Structure.new do
        # The Amazon Standard Identification Number, which identifies the detail page identifier.
        attribute?(:asin, String)

        # The Fulfillment Network SKU, which identifies a real fulfillable item with catalog data and condition.
        attribute?(:fnsku, String)

        # The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute?(:msku, String)

        attribute?(:tax_details, TaxDetails, from: "taxDetails")
      end
    end
  end
end
