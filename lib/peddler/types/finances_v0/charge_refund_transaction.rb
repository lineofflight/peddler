# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # The charge refund transaction.
      ChargeRefundTransaction = Structure.new do
        # @return [Types::Money] The amount of the charge refund credit.
        attribute(:charge_amount, Types::Money, from: "ChargeAmount")

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "ChargeType")
      end
    end
  end
end
