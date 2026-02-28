# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The payload for the `getFeatureSKU` operation.
      GetFeatureSKUResult = Structure.new do
        # @return [String] The name of the feature.
        attribute(:feature_name, String, null: false, from: "featureName")

        # @return [:boolean] When true, the seller SKU is eligible for the requested feature.
        attribute(:eligible, :boolean, null: false, from: "isEligible")

        # @return [String] The requested marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<String>] A list of one or more reasons that the seller SKU is ineligible for the feature.
        #
        # Possible values:
        # * `MERCHANT_NOT_ENROLLED`: The merchant isn't enrolled for the feature.
        # * `SKU_NOT_ELIGIBLE`: The SKU doesn't reside in a warehouse that supports the feature.
        # * `INVALID_SKU`: There is an issue with the SKU provided.
        attribute?(:ineligible_reasons, [String], from: "ineligibleReasons")

        # @return [FeatureSKU] Information about the SKU, including the count available, identifiers, and a list of
        #   overlapping SKUs that share the same inventory pool.
        attribute?(:sku_info, FeatureSKU, from: "skuInfo")
      end
    end
  end
end
