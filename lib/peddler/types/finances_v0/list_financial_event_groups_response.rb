# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/list_financial_event_groups_payload"
require "peddler/types/finances_v0/error"

module Peddler
  module Types
    module FinancesV0
      # The response schema for the listFinancialEventGroups operation.
      ListFinancialEventGroupsResponse = Structure.new do
        # @return [ListFinancialEventGroupsPayload] The payload for the listFinancialEventGroups operation.
        attribute(:payload, ListFinancialEventGroupsPayload)

        # @return [Array<Error>] One or more unexpected errors occurred during the listFinancialEventGroups operation.
        attribute(:errors, [Error])
      end
    end
  end
end
