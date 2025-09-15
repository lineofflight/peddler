# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A payment event for Fulfillment by Amazon (FBA) inventory liquidation. This event is used only in the US
      # marketplace.
      FBALiquidationEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] The identifier for the original removal order.
        attribute(:original_removal_order_id, String, from: "OriginalRemovalOrderId")

        # @return [Currency] The amount paid by the liquidator for the seller's inventory. The seller receives this
        # amount minus LiquidationFeeAmount.
        attribute(:liquidation_proceeds_amount, Currency, from: "LiquidationProceedsAmount")

        # @return [Currency] The fee charged to the seller by Amazon for liquidating the seller's FBA inventory.
        attribute(:liquidation_fee_amount, Currency, from: "LiquidationFeeAmount")
      end
    end
  end
end
