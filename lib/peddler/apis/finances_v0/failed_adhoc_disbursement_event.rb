# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # Failed ad hoc disbursement event list.
      FailedAdhocDisbursementEvent = Structure.new do
        # The disbursement identifier.
        attribute?(:disbursement_id, String, from: "DisbursementId")

        # The type of fund transfer. For example, `Refund`.
        attribute?(:funds_transfers_type, String, from: "FundsTransfersType")

        # The type of payment for disbursement. For example, `CREDIT_CARD`.
        attribute?(:payment_disbursement_type, String, from: "PaymentDisbursementType")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The status of the failed `AdhocDisbursement`. For example, `HARD_DECLINED`.
        attribute?(:status, String, from: "Status")

        # The amount of the Adhoc Disbursement.
        attribute?(:transfer_amount, Money, from: "TransferAmount")

        # The transfer identifier.
        attribute?(:transfer_id, String, from: "TransferId")
      end
    end
  end
end
