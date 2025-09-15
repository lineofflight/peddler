# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # The charge refund transaction.
      ChargeRefundTransaction = Structure.new do
        # @return [Currency] The amount of the charge refund credit.
        attribute(:charge_amount, Currency, from: "ChargeAmount")

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "ChargeType")
      end
    end
  end
end
