# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # The payload for the `listTransactions` operation.
      ListTransactionsPayload = Structure.new do
        # @return [String] When present and not empty, pass this string token in the next request to return the next
        #   response page.
        attribute?(:next_token, String, from: "NextToken")

        # @return [Array<Transaction>]
        attribute?(:transactions, [Transaction], from: "Transactions")
      end
    end
  end
end
