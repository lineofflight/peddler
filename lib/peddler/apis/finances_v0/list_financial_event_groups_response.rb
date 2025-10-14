# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # The response schema for the listFinancialEventGroups operation.
      ListFinancialEventGroupsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the listFinancialEventGroups operation.
        attribute?(:errors, [Error])

        # @return [ListFinancialEventGroupsPayload] The payload for the listFinancialEventGroups operation.
        attribute?(:payload, ListFinancialEventGroupsPayload)
      end
    end
  end
end
