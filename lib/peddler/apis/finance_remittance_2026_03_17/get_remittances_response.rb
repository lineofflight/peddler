# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinanceRemittance20260317
      # The response for the `getRemittanceHeaders` operation.
      GetRemittancesResponse = Structure.new do
        # A token to fetch the next page of results. Present when more results are available.
        attribute?(:next_token, String, from: "nextToken")

        # The total number of records across all pages.
        attribute?(:num_of_records, Integer, from: "numOfRecords")

        # A list of remittance summaries.
        attribute?(:remittances, [RemittanceHeader])
      end
    end
  end
end
