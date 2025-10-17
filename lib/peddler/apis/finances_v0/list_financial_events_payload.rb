# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # The payload for the listFinancialEvents operation.
      ListFinancialEventsPayload = Structure.new do
        # @return [FinancialEvents]
        attribute?(:financial_events, FinancialEvents, from: "FinancialEvents")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        #   response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
