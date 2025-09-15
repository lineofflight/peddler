# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/list_all_fulfillment_orders_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `listAllFulfillmentOrders` operation.
      ListAllFulfillmentOrdersResponse = Structure.new do
        # @return [ListAllFulfillmentOrdersResult] The payload for the `listAllFulfillmentOrders` operation.
        attribute(:payload, ListAllFulfillmentOrdersResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `listAllFulfillmentOrders` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
