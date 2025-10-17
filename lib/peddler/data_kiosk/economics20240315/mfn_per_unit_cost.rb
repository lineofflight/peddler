# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The item level per unit cost provided by the seller and applicable to Merchant Fulfilled Network (MFN) products.
      # Fields in this type will be null if not provided by the seller.
      MfnPerUnitCost = Structure.new do
        # @return [Amount] Cost of fulfilling an order containing the product, including labor, packing material,
        #   shipping to customer, customer service etc. This value is provided by the seller and applicable to Merchant
        #   Fulfilled Network (MFN) products.
        attribute?(:fulfillment_cost, Amount, from: "fulfillmentCost")

        # @return [Amount] Cost to store a single unit of the product per month. This value is provided by the seller
        #   and applicable to Merchant Fulfilled Network (MFN) products.
        attribute?(:storage_cost, Amount, from: "storageCost")
      end
    end
  end
end
