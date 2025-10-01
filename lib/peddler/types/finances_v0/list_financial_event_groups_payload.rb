# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/finances_v0/financial_event_group"

module Peddler
  module Types
    module FinancesV0
      # The payload for the listFinancialEventGroups operation.
      ListFinancialEventGroupsPayload = Structure.new do
        # @return [Array<FinancialEventGroup>]
        attribute?(:financial_event_group_list, [FinancialEventGroup], from: "FinancialEventGroupList")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
