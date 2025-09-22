# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"
require "peddler/types/finances_v0/safet_reimbursement_item"

module Peddler
  module Types
    module FinancesV0
      # A SAFE-T claim reimbursement on the seller's account.
      SAFETReimbursementEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] A SAFE-T claim identifier.
        attribute(:safet_claim_id, String, from: "SAFETClaimId")

        # @return [Currency] The amount of the reimbursement.
        attribute(:reimbursed_amount, Currency, from: "ReimbursedAmount")

        # @return [String] Indicates why the seller was reimbursed.
        attribute(:reason_code, String, from: "ReasonCode")

        # @return [Array<SAFETReimbursementItem>]
        attribute(:safet_reimbursement_item_list, [SAFETReimbursementItem], from: "SAFETReimbursementItemList")
      end
    end
  end
end
