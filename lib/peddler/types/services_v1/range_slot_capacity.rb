# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/range_capacity"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `getRangeSlotCapacity` operation.
      RangeSlotCapacity = Structure.new do
        # @return [String] Resource Identifier.
        attribute?(:resource_id, String, from: "resourceId")

        # @return [Array<RangeCapacity>] Array of range capacities where each entry is for a specific capacity type.
        attribute?(:capacities, [RangeCapacity])

        # @return [String] Next page token, if there are more pages.
        attribute?(:next_page_token, String, from: "nextPageToken")
      end
    end
  end
end
