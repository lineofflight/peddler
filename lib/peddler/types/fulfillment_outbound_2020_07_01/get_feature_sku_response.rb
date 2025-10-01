# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_feature_sku_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFeatureSKU` operation.
      GetFeatureSkuResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetFeatureSkuResult]
        attribute?(:payload, GetFeatureSkuResult)
      end
    end
  end
end
