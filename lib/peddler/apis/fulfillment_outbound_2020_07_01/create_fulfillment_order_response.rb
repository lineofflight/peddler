# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The response schema for the `createFulfillmentOrder` operation.
      CreateFulfillmentOrderResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createFulfillmentOrder` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
