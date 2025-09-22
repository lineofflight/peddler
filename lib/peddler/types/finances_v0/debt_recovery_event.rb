# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"
require "peddler/types/finances_v0/debt_recovery_item"
require "peddler/types/finances_v0/charge_instrument"

module Peddler
  module Types
    module FinancesV0
      # A debt payment or debt adjustment.
      DebtRecoveryEvent = Structure.new do
        # @return [String] The debt recovery type.
        #
        # Possible values:
        #
        # * DebtPayment
        #
        # * DebtPaymentFailure
        #
        # * DebtAdjustment
        attribute(:debt_recovery_type, String, from: "DebtRecoveryType")

        # @return [Currency] The amount applied for recovery.
        attribute(:recovery_amount, Currency, from: "RecoveryAmount")

        # @return [Currency] The amount returned for overpayment.
        attribute(:over_payment_credit, Currency, from: "OverPaymentCredit")

        # @return [Array<DebtRecoveryItem>]
        attribute(:debt_recovery_item_list, [DebtRecoveryItem], from: "DebtRecoveryItemList")

        # @return [Array<ChargeInstrument>]
        attribute(:charge_instrument_list, [ChargeInstrument], from: "ChargeInstrumentList")
      end
    end
  end
end
