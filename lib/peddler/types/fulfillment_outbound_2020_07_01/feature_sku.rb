# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Information about an SKU, including the count available, identifiers, and a list of overlapping SKUs that share
      # the same inventory pool.
      FeatureSku = Structure.new do
        # @return [String] Used to identify an item in the given marketplace. `SellerSKU` is qualified by the seller's
        # SellerId, which is included with every operation that you submit.
        attribute?(:seller_sku, String, from: "sellerSku")

        # @return [String] The unique SKU used by Amazon's fulfillment network.
        attribute?(:fn_sku, String, from: "fnSku")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [Float] The number of SKUs available for this service.
        attribute?(:sku_count, Float, from: "skuCount")

        # @return [Array<String>] Other seller SKUs that are shared across the same inventory.
        attribute?(:overlapping_skus, [String], from: "overlappingSkus")
      end
    end
  end
end
