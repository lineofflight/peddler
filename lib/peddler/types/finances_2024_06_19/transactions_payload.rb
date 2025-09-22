# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_2024_06_19/transaction"

module Peddler
  module Types
    module Finances20240619
      # The payload for the `listTransactions` operation.
      TransactionsPayload = Structure.new do
        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute(:next_token, String, from: "nextToken")

        # @return [Array<Transaction>]
        attribute(:transactions, [Transaction])
      end
    end
  end
end
