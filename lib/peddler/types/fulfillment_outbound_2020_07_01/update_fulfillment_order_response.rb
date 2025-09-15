# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `updateFulfillmentOrder` operation.
      UpdateFulfillmentOrderResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `updateFulfillmentOrder` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
