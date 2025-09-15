# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/create_return_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The `createFulfillmentReturn` operation creates a fulfillment return for items that were fulfilled using the
      # `createFulfillmentOrder` operation. For calls to `createFulfillmentReturn`, you must include `returnReasonCode`
      # values returned by a previous call to the `listReturnReasonCodes` operation.
      CreateFulfillmentReturnRequest = Structure.new do
        # @return [Array<CreateReturnItem>]
        attribute(:items, [CreateReturnItem])
      end
    end
  end
end
