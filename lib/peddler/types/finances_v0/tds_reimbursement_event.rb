# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FinancesV0
      # An event related to a Tax-Deducted-at-Source (TDS) reimbursement.
      TDSReimbursementEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Money] The amount reimbursed.
        attribute?(:reimbursed_amount, Money, from: "ReimbursedAmount")

        # @return [String] The Tax-Deducted-at-Source (TDS) identifier.
        attribute?(:tds_order_id, String, from: "TDSOrderId")
      end
    end
  end
end
