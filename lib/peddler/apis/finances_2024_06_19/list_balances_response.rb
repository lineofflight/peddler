# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # The response to the `listBalances` operation.
      ListBalancesResponse = Structure.new do
        # @return [Array<Balance>]
        attribute?(:balances, [Balance])

        # @return [String] A token to retrieve the next page of results. If null, no more results are available.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
