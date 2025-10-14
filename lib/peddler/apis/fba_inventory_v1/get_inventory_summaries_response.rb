# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # The Response schema.
      GetInventorySummariesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the getInventorySummaries operation.
        attribute?(:errors, [Error])

        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [GetInventorySummariesResult] The payload for the getInventorySummaries operation.
        attribute?(:payload, GetInventorySummariesResult)
      end
    end
  end
end
