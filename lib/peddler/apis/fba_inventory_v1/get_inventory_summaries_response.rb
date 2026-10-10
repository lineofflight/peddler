# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FBAInventoryV1
      # The Response schema.
      GetInventorySummariesResponse = Structure.new do
        # One or more unexpected errors occurred during the getInventorySummaries operation.
        attribute?(:errors, [Error])

        attribute?(:pagination, Pagination)

        # The payload for the getInventorySummaries operation.
        attribute?(:payload, GetInventorySummariesResult)
      end
    end
  end
end
