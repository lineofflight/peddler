# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
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
