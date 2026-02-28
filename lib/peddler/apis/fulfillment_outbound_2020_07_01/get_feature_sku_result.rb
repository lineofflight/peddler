# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The payload for the `getFeatureSKU` operation.
      GetFeatureSKUResult = Structure.new do
        # @return [String] The name of the feature.
        attribute(:feature_name, String, from: "featureName")

        # @return [:boolean] When true, the seller SKU is eligible for the requested feature.
        attribute(:eligible, :boolean, from: "isEligible")

        # @return [String] The requested marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] The unique SKU used by Amazon's fulfillment network.
        attribute?(:fn_sku, String, from: "fnSku")

        # @return [Array<String>] A list of one or more reasons that the seller SKU is ineligible for the feature.
        #
        # Possible values:
        # * `MERCHANT_NOT_ENROLLED`: The merchant isn't enrolled for the feature.
        # * `SKU_NOT_ELIGIBLE`: The SKU doesn't reside in a warehouse that supports the feature.
        # * `INVALID_SKU`: There is an issue with the SKU provided.
        attribute?(:ineligible_reasons, [String], from: "ineligibleReasons")

        # @return [String] Used to identify an item in the given marketplace. SellerSKU is qualified by the seller's
        #   SellerId, which is included with every operation that you submit.
        attribute?(:seller_sku, String, from: "sellerSku")

        # @return [Float] The number of SKUs available for this service.
        attribute?(:sku_count, Float, from: "skuCount")
      end
    end
  end
end
