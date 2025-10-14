# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The result for the `createFulfillmentReturn` operation.
      CreateFulfillmentReturnResult = Structure.new do
        # @return [Array<InvalidReturnItem>]
        attribute?(:invalid_return_items, [InvalidReturnItem], from: "invalidReturnItems")

        # @return [Array<ReturnAuthorization>]
        attribute?(:return_authorizations, [ReturnAuthorization], from: "returnAuthorizations")

        # @return [Array<ReturnItem>]
        attribute?(:return_items, [ReturnItem], from: "returnItems")
      end
    end
  end
end
