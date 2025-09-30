# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The request body schema for the `submitFulfillmentOrderStatusUpdate` operation.
      SubmitFulfillmentOrderStatusUpdateRequest = Structure.new do
        # @return [String]
        attribute?(:fulfillment_order_status, String, from: "fulfillmentOrderStatus")
      end
    end
  end
end
