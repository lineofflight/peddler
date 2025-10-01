# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/finances_v0/error"
require "peddler/types/finances_v0/list_financial_events_payload"

module Peddler
  module Types
    module FinancesV0
      # The response schema for the listFinancialEvents operation.
      ListFinancialEventsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the listFinancialEvents operation.
        attribute?(:errors, [Error])

        # @return [ListFinancialEventsPayload] The payload for the listFinancialEvents operation.
        attribute?(:payload, ListFinancialEventsPayload)
      end
    end
  end
end
