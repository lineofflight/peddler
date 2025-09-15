# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Information about whether or not a buyer requested cancellation.
      BuyerRequestedCancel = Structure.new do
        # @return [String] Indicate whether the buyer has requested cancellation.
        #
        # **Possible Values**: `true`, `false`.
        attribute(:is_buyer_requested_cancel, String, from: "IsBuyerRequestedCancel")

        # @return [String] The reason that the buyer requested cancellation.
        attribute(:buyer_cancel_reason, String, from: "BuyerCancelReason")
      end
    end
  end
end
