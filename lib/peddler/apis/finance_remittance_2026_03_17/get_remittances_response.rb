# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinanceRemittance20260317
      # The response for the `getRemittanceHeaders` operation.
      GetRemittancesResponse = Structure.new do
        # @return [String] A token to fetch the next page of results. Present when more results are available.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Integer] The total number of records across all pages.
        attribute?(:num_of_records, Integer, from: "numOfRecords")

        # @return [Array<RemittanceHeader>] A list of remittance summaries.
        attribute?(:remittances, [RemittanceHeader])
      end
    end
  end
end
