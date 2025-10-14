# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # The response schema for the `listTransactions` operation.
      ListTransactionsResponse = Structure.new do
        # @return [TransactionsPayload] The payload for the `listTransactions` operation.
        attribute?(:payload, TransactionsPayload)
      end
    end
  end
end
