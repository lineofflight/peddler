# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Detailed information about how the cancellation was processed for a specific order item.
      ItemCancellationExecution = Structure.new do
        # The provided explanation for why the cancellation occurred.
        attribute?(:cancel_reason, String, from: "cancelReason")

        # The entity that executed the cancellation for this item.
        #
        # **Possible values**: `BUYER`, `MERCHANT`, `AMAZON`.
        attribute?(:cancelled_by, String, from: "cancelledBy")
      end
    end
  end
end
