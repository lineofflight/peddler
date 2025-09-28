# frozen_string_literal: true

require "peddler/types/finances_v0/charge_refund_transaction"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `ChargeRefund` transactions
      class ChargeRefundTransactions < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ChargeRefundTransaction.parse(item) }) : new
          end
        end
      end
    end
  end
end
