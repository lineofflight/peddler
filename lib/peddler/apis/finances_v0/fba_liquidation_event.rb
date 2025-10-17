# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A payment event for Fulfillment by Amazon (FBA) inventory liquidation. This event is used only in the US
      # marketplace.
      FBALiquidationEvent = Structure.new do
        # @return [Money] The fee charged to the seller by Amazon for liquidating the seller's FBA inventory.
        attribute?(:liquidation_fee_amount, Money, from: "LiquidationFeeAmount")

        # @return [Money] The amount paid by the liquidator for the seller's inventory. The seller receives this amount
        #   minus LiquidationFeeAmount.
        attribute?(:liquidation_proceeds_amount, Money, from: "LiquidationProceedsAmount")

        # @return [String] The identifier for the original removal order.
        attribute?(:original_removal_order_id, String, from: "OriginalRemovalOrderId")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")
      end
    end
  end
end
