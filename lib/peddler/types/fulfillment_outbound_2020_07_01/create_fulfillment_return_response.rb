# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/create_fulfillment_return_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `createFulfillmentReturn` operation.
      CreateFulfillmentReturnResponse = Structure.new do
        # @return [CreateFulfillmentReturnResult] The payload for the `createFulfillmentReturn` operation.
        attribute?(:payload, CreateFulfillmentReturnResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `createFulfillmentReturn` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
