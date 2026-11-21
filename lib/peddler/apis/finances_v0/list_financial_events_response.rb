# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # The response schema for the `listFinancialEvents` operation.
      ListFinancialEventsResponse = Structure.new do
        # One or more unexpected errors occurred during the `listFinancialEvents` operation.
        attribute?(:errors, [Error])

        # The payload for the `listFinancialEvents` operation.
        attribute?(:payload, ListFinancialEventsPayload)
      end
    end
  end
end
