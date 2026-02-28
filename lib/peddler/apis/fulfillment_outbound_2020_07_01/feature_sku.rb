# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Information about an SKU, including the count available, identifiers, and a list of overlapping SKUs that share
      # the same inventory pool.
      FeatureSKU = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] The unique SKU used by Amazon's fulfillment network.
        attribute?(:fn_sku, String, from: "fnSku")

        # @return [Array<String>] Other seller SKUs that are shared across the same inventory.
        attribute?(:overlapping_skus, [String], from: "overlappingSkus")

        # @return [String] Used to identify an item in the given marketplace. `SellerSKU` is qualified by the seller's
        #   SellerId, which is included with every operation that you submit.
        attribute?(:seller_sku, String, from: "sellerSku")

        # @return [Float] The number of SKUs available for this service.
        attribute?(:sku_count, Float, from: "skuCount")
      end
    end
  end
end
