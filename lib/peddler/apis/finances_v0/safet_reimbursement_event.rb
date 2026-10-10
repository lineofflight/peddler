# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A SAFE-T claim reimbursement on the seller's account.
      SAFETReimbursementEvent = Structure.new do
        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # Indicates why the seller was reimbursed.
        attribute?(:reason_code, String, from: "ReasonCode")

        # The amount of the reimbursement.
        attribute?(:reimbursed_amount, Money, from: "ReimbursedAmount")

        # A SAFE-T claim identifier.
        attribute?(:safet_claim_id, String, from: "SAFETClaimId")

        attribute?(:safet_reimbursement_item_list, [SAFETReimbursementItem], from: "SAFETReimbursementItemList")
      end
    end
  end
end
