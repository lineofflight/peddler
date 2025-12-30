# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An event related to charge refund.
      ChargeRefundEvent = Structure.new do
        # @return [Array<ChargeRefundTransaction>] The amount of the charge refund credit.
        attribute?(:charge_refund_transactions, [ChargeRefundTransaction], from: "ChargeRefundTransactions")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The reason given for a charge refund. For example, `SubscriptionFeeCorrection`.
        attribute?(:reason_code, String, from: "ReasonCode")

        # @return [String] A description of the Reason Code. For example, `SubscriptionFeeCorrection`.
        attribute?(:reason_code_description, String, from: "ReasonCodeDescription")
      end
    end
  end
end
