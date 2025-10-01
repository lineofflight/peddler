# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_fulfillment_order_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFulfillmentOrder` operation.
      GetFulfillmentOrderResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getFulfillmentOrder` operation.
        attribute?(:errors, [Error])

        # @return [GetFulfillmentOrderResult] The payload for the `getFulfillmentOrder` operation.
        attribute?(:payload, GetFulfillmentOrderResult)
      end
    end
  end
end
