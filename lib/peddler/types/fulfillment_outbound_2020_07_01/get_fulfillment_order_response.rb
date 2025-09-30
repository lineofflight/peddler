# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/get_fulfillment_order_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFulfillmentOrder` operation.
      GetFulfillmentOrderResponse = Structure.new do
        # @return [GetFulfillmentOrderResult] The payload for the `getFulfillmentOrder` operation.
        attribute?(:payload, GetFulfillmentOrderResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getFulfillmentOrder` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
