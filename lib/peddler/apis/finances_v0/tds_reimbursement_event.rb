# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to a Tax-Deducted-at-Source (TDS) reimbursement.
      TDSReimbursementEvent = Structure.new do
        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The amount reimbursed.
        attribute?(:reimbursed_amount, Money, from: "ReimbursedAmount")

        # The Tax-Deducted-at-Source (TDS) identifier.
        attribute?(:tds_order_id, String, from: "TDSOrderId")
      end
    end
  end
end
