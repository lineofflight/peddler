# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The `createFulfillmentReturn` operation creates a fulfillment return for items that were fulfilled using the
      # `createFulfillmentOrder` operation. For calls to `createFulfillmentReturn`, you must include `returnReasonCode`
      # values returned by a previous call to the `listReturnReasonCodes` operation.
      CreateFulfillmentReturnRequest = Structure.new do
        # @return [Array<CreateReturnItem>]
        attribute(:items, [CreateReturnItem], null: false)
      end
    end
  end
end
