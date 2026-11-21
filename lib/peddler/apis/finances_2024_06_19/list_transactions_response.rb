# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # The response to the `listTransactions` operation.
      ListTransactionsResponse = Structure.new do
        # The payload for the `listTransactions` operation.
        attribute?(:payload, TransactionsPayload)
      end
    end
  end
end
