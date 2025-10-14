# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
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
