# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/invalid_return_item"
require "peddler/types/fulfillment_outbound_2020_07_01/return_authorization"
require "peddler/types/fulfillment_outbound_2020_07_01/return_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
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
