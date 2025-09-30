# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_2024_06_19/transactions_payload"

module Peddler
  module Types
    module Finances20240619
      # The response schema for the `listTransactions` operation.
      ListTransactionsResponse = Structure.new do
        # @return [TransactionsPayload] The payload for the `listTransactions` operation.
        attribute?(:payload, TransactionsPayload)
      end
    end
  end
end
