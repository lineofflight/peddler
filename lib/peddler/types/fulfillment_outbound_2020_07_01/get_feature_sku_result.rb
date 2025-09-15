# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/feature_sku"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The payload for the `getFeatureSKU` operation.
      GetFeatureSkuResult = Structure.new do
        # @return [String] The requested marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the feature.
        attribute(:feature_name, String, from: "featureName")

        # @return [:boolean] When true, the seller SKU is eligible for the requested feature.
        attribute(:is_eligible, :boolean, from: "isEligible")

        # @return [Array<String>] A list of one or more reasons that the seller SKU is ineligible for the feature.
        #
        # Possible values:
        # * `MERCHANT_NOT_ENROLLED`: The merchant isn't enrolled for the feature.
        # * `SKU_NOT_ELIGIBLE`: The SKU doesn't reside in a warehouse that supports the feature.
        # * `INVALID_SKU`: There is an issue with the SKU provided.
        attribute(:ineligible_reasons, [String], from: "ineligibleReasons")

        # @return [FeatureSku] Information about the SKU, including the count available, identifiers, and a list of
        # overlapping SKUs that share the same inventory pool.
        attribute(:sku_info, FeatureSku, from: "skuInfo")
      end
    end
  end
end
