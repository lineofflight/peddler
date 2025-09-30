# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_order"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The request for the `listAllFulfillmentOrders` operation.
      ListAllFulfillmentOrdersResult = Structure.new do
        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<FulfillmentOrder>] An array of fulfillment order information.
        attribute?(:fulfillment_orders, [FulfillmentOrder], from: "fulfillmentOrders")
      end
    end
  end
end
