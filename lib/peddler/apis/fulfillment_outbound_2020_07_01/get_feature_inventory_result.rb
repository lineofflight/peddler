# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The payload for the `getEligibleInventory` operation.
      GetFeatureInventoryResult = Structure.new do
        # @return [String] The name of the feature.
        attribute(:feature_name, String, from: "featureName")

        # @return [String] The requested marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<FeatureSku>] An array of SKUs eligible for this feature and the quantity available.
        attribute?(:feature_skus, [FeatureSKU], from: "featureSkus")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
