# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_features_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFeatures` operation.
      GetFeaturesResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetFeaturesResult]
        attribute?(:payload, GetFeaturesResult)
      end
    end
  end
end
