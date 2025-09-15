# frozen_string_literal: true

require "peddler/types/finances_v0/list_financial_events_payload"
require "peddler/types/finances_v0/error"

module Peddler
  module Types
    module FinancesV0
      # The response schema for the listFinancialEvents operation.
      ListFinancialEventsResponse = Structure.new do
        # @return [ListFinancialEventsPayload] The payload for the listFinancialEvents operation.
        attribute(:payload, ListFinancialEventsPayload)

        # @return [Array<Error>] One or more unexpected errors occurred during the listFinancialEvents operation.
        attribute(:errors, [Error])
      end
    end
  end
end
