# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An adjustment to the seller's account.
      AdjustmentEvent = Structure.new do
        # @return [Money] The amount adjusted as part of this event.
        attribute?(:adjustment_amount, Money, from: "AdjustmentAmount")

        # @return [Array<AdjustmentItem>] A list of information about adjustments to an account.
        attribute?(:adjustment_item_list, [AdjustmentItem], from: "AdjustmentItemList")

        # @return [String] The type of adjustment.
        #
        # Possible values:
        #
        # * FBAInventoryReimbursement - An FBA inventory reimbursement to a seller's account. This occurs if a seller's
        # inventory is damaged.
        #
        # * ReserveEvent - A reserve event that is generated at the time of a settlement period closing. This occurs
        # when some money from a seller's account is held back.
        #
        # * PostageBilling - The amount paid by a seller for shipping labels.
        #
        # * PostageRefund - The reimbursement of shipping labels purchased for orders that were canceled or refunded.
        #
        # * LostOrDamagedReimbursement - An Amazon Easy Ship reimbursement to a seller's account for a package that we
        # lost or damaged.
        #
        # * CanceledButPickedUpReimbursement - An Amazon Easy Ship reimbursement to a seller's account. This occurs when
        # a package is picked up and the order is subsequently canceled. This value is used only in the India
        # marketplace.
        #
        # * ReimbursementClawback - An Amazon Easy Ship reimbursement clawback from a seller's account. This occurs when
        # a prior reimbursement is reversed. This value is used only in the India marketplace.
        #
        # * SellerRewards - An award credited to a seller's account for their participation in an offer in the Seller
        # Rewards program. Applies only to the India marketplace.
        attribute?(:adjustment_type, String, from: "AdjustmentType")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The name of the store where the event occurred.
        attribute?(:store_name, String, from: "StoreName")
      end
    end
  end
end
