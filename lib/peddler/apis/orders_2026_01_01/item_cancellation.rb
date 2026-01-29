# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The cancellation information of the order item.
      ItemCancellation = Structure.new do
        # @return [ItemCancellationRequest] Details of the cancellation request submitted for this order item.
        attribute?(:cancellation_request, ItemCancellationRequest, from: "cancellationRequest")
      end
    end
  end
end
