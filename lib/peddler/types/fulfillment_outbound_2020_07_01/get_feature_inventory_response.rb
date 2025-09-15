# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/get_feature_inventory_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The breakdown of eligibility inventory by feature.
      GetFeatureInventoryResponse = Structure.new do
        # @return [GetFeatureInventoryResult]
        attribute(:payload, GetFeatureInventoryResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getFeatureInventory` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
