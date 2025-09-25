# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FinancesV0
      # The charge refund transaction.
      ChargeRefundTransaction = Structure.new do
        # @return [Money] The amount of the charge refund credit.
        attribute(:charge_amount, Money, from: "ChargeAmount")

        # @return [String] The type of charge.
        attribute(:charge_type, String, from: "ChargeType")
      end
    end
  end
end
