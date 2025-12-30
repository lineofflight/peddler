# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # The response schema for the `listTransactions` operation.
      ListTransactionsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `listTransactions` operation.
        attribute?(:errors, [Error])

        # @return [ListTransactionsPayload] The payload for the `listTransactions` operation.
        attribute?(:payload, ListTransactionsPayload)
      end
    end
  end
end
