# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/create_fulfillment_return_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `createFulfillmentReturn` operation.
      CreateFulfillmentReturnResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createFulfillmentReturn` operation.
        attribute?(:errors, [Error])

        # @return [CreateFulfillmentReturnResult] The payload for the `createFulfillmentReturn` operation.
        attribute?(:payload, CreateFulfillmentReturnResult)
      end
    end
  end
end
