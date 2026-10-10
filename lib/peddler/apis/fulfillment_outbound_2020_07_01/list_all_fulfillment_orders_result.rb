# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The request for the `listAllFulfillmentOrders` operation.
      ListAllFulfillmentOrdersResult = Structure.new do
        # An array of fulfillment order information.
        attribute?(:fulfillment_orders, [FulfillmentOrder], from: "fulfillmentOrders")

        # When present and not empty, pass this string token in the next request to return the next response page.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
