# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The response schema for the `listOrders` operation.
      ListOrdersResponse = Structure.new do
        # A list of fulfillment orders.
        attribute(:orders, [FulfillmentOrder], null: false)

        attribute?(:pagination, Pagination)
      end
    end
  end
end
