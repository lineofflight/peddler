# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_feature_inventory_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The breakdown of eligibility inventory by feature.
      GetFeatureInventoryResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getFeatureInventory` operation.
        attribute?(:errors, [Error])

        # @return [GetFeatureInventoryResult]
        attribute?(:payload, GetFeatureInventoryResult)
      end
    end
  end
end
