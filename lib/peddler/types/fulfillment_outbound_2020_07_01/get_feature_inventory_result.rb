# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/feature_sku"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The payload for the `getEligibleInventory` operation.
      GetFeatureInventoryResult = Structure.new do
        # @return [String] The requested marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the feature.
        attribute(:feature_name, String, from: "featureName")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute(:next_token, String, from: "nextToken")

        # @return [Array<FeatureSku>] An array of SKUs eligible for this feature and the quantity available.
        attribute(:feature_skus, [FeatureSku], from: "featureSkus")
      end
    end
  end
end
