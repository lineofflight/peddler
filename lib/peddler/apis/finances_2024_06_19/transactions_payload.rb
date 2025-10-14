# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # The payload for the `listTransactions` operation.
      TransactionsPayload = Structure.new do
        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<Transaction>]
        attribute?(:transactions, [Transaction])
      end
    end
  end
end
