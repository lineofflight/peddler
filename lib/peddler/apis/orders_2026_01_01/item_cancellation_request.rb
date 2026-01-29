# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Detailed information about a cancellation request submitted for a specific order item.
      ItemCancellationRequest = Structure.new do
        # @return [String] Explanation provided for why the cancellation was requested.
        attribute?(:cancel_reason, String, from: "cancelReason")

        # @return [String] Entity that initiated the cancellation request for this item.
        #
        # **Possible values**: `BUYER`
        attribute?(:requester, String)
      end
    end
  end
end
