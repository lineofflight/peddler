# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # An event related to a Tax-Deducted-at-Source (TDS) reimbursement.
      TDSReimbursementEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] The Tax-Deducted-at-Source (TDS) identifier.
        attribute(:tds_order_id, String, from: "TDSOrderId")

        # @return [Money] The amount reimbursed.
        attribute(:reimbursed_amount, Money, from: "ReimbursedAmount")
      end
    end
  end
end
