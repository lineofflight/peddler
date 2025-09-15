# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/get_features_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFeatures` operation.
      GetFeaturesResponse = Structure.new do
        # @return [GetFeaturesResult]
        attribute(:payload, GetFeaturesResult)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
