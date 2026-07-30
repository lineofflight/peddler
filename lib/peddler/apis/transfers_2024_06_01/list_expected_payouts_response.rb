# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # The response schema for the `listExpectedPayouts` operation.
      ListExpectedPayoutsResponse = Structure.new do
        # @return [Array<ExpectedPayout>] A list of expected payouts for all of the selling partner's accounts matching
        #   the filters.
        attribute?(:expected_payouts, [ExpectedPayout], from: "expectedPayouts")

        # @return [String] The response includes `nextToken` when the number of results exceeds the specified page size.
        #   To get the next page of results, call the operation with this token and include the same arguments as the
        #   call that produced the token. To get a complete list, call this operation until `nextToken` is null. Note
        #   that this operation can return empty pages.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
