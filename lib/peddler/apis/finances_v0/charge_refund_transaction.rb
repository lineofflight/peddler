# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # The charge refund transaction.
      ChargeRefundTransaction = Structure.new do
        # The amount of the charge refund credit.
        attribute?(:charge_amount, Money, from: "ChargeAmount")

        # The type of charge.
        attribute?(:charge_type, String, from: "ChargeType")
      end
    end
  end
end
