# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A debt payment or debt adjustment.
      DebtRecoveryEvent = Structure.new do
        attribute?(:charge_instrument_list, [ChargeInstrument], from: "ChargeInstrumentList")

        attribute?(:debt_recovery_item_list, [DebtRecoveryItem], from: "DebtRecoveryItemList")

        # The debt recovery type.
        #
        # Possible values:
        #
        # * `DebtPayment` * `DebtPaymentFailure` * `DebtAdjustment`
        attribute?(:debt_recovery_type, String, from: "DebtRecoveryType")

        # The amount returned for overpayment.
        attribute?(:over_payment_credit, Money, from: "OverPaymentCredit")

        # The amount applied for recovery.
        attribute?(:recovery_amount, Money, from: "RecoveryAmount")
      end
    end
  end
end
