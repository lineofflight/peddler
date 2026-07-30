# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Details of how the cancellation was executed for a specific order item, including who performed the cancellation
      # and the reason.
      ItemCancellationExecution = Structure.new do
        # @return [String] Explanation provided for why the cancellation was executed.
        attribute?(:cancel_reason, String, from: "cancelReason")

        # @return [String] Entity that executed the cancellation for this item.
        #
        # **Possible values**: `BUYER`, `MERCHANT`, `AMAZON`
        attribute?(:cancelled_by, String, from: "cancelledBy")
      end
    end
  end
end
