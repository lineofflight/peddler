# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Information about whether or not a buyer requested cancellation.
      BuyerRequestedCancel = Structure.new do
        # @return [String] The reason that the buyer requested cancellation.
        attribute?(:buyer_cancel_reason, String, from: "BuyerCancelReason")

        # @return [String] Indicate whether the buyer has requested cancellation.
        #
        # **Possible Values**: `true`, `false`.
        attribute?(:is_buyer_requested_cancel, String, from: "IsBuyerRequestedCancel")
      end
    end
  end
end
