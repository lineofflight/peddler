# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `createFulfillmentOrder` operation.
      CreateFulfillmentOrderResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createFulfillmentOrder` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
