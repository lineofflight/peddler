# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The request body schema for the `submitFulfillmentOrderStatusUpdate` operation.
      SubmitFulfillmentOrderStatusUpdateRequest = Structure.new do
        # Known values: `New`, `Received`, `Planning`, `Processing`, `Cancelled`, `Complete`, `CompletePartialled`,
        # `Unfulfillable`, `Invalid`.
        attribute?(:fulfillment_order_status, String, from: "fulfillmentOrderStatus")
      end
    end
  end
end
