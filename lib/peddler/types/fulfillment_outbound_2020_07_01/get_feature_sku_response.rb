# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/get_feature_sku_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFeatureSKU` operation.
      GetFeatureSkuResponse = Structure.new do
        # @return [GetFeatureSkuResult]
        attribute(:payload, GetFeatureSkuResult)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
