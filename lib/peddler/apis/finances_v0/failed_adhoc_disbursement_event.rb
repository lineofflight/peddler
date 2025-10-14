# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # Failed ad hoc disbursement event list.
      FailedAdhocDisbursementEvent = Structure.new do
        # @return [String] The disbursement identifier.
        attribute?(:disbursement_id, String, from: "DisbursementId")

        # @return [String] The type of fund transfer.
        #
        # Example "Refund"
        attribute?(:funds_transfers_type, String, from: "FundsTransfersType")

        # @return [String] The type of payment for disbursement.
        #
        # Example `CREDIT_CARD`
        attribute?(:payment_disbursement_type, String, from: "PaymentDisbursementType")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The status of the failed `AdhocDisbursement`.
        #
        # Example `HARD_DECLINED`
        attribute?(:status, String, from: "Status")

        # @return [Money] The amount of the Adhoc Disbursement.
        attribute?(:transfer_amount, Money, from: "TransferAmount")

        # @return [String] The transfer identifier.
        attribute?(:transfer_id, String, from: "TransferId")
      end
    end
  end
end
