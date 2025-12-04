# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # The payload for the `listTransactions` operation.
      TransactionsPayload = Structure.new do
        # @return [String] The response includes `nextToken` when the number of results exceeds the specified `pageSize`
        #   value. To get the next page of results, call the operation with this token and include the same arguments as
        #   the call that produced the token. To get a complete list, call this operation until `nextToken` is null.
        #   Note that this operation can return empty pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<Transaction>]
        attribute?(:transactions, [Transaction])
      end
    end
  end
end
