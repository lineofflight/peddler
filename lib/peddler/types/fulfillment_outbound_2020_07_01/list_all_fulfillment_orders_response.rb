# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/list_all_fulfillment_orders_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `listAllFulfillmentOrders` operation.
      ListAllFulfillmentOrdersResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `listAllFulfillmentOrders` operation.
        attribute?(:errors, [Error])

        # @return [ListAllFulfillmentOrdersResult] The payload for the `listAllFulfillmentOrders` operation.
        attribute?(:payload, ListAllFulfillmentOrdersResult)
      end
    end
  end
end
