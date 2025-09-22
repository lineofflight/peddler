# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/charge_refund_transaction"

module Peddler
  module Types
    module FinancesV0
      # An event related to charge refund.
      ChargeRefundEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] The reason given for a charge refund.
        #
        # Example: `SubscriptionFeeCorrection`
        attribute(:reason_code, String, from: "ReasonCode")

        # @return [String] A description of the Reason Code.
        #
        # Example: `SubscriptionFeeCorrection`
        attribute(:reason_code_description, String, from: "ReasonCodeDescription")

        # @return [Array<ChargeRefundTransaction>] The amount of the charge refund credit.
        attribute(:charge_refund_transactions, [ChargeRefundTransaction], from: "ChargeRefundTransactions")
      end
    end
  end
end
