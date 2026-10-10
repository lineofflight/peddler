# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Response schema for the `getRangeSlotCapacity` operation.
      RangeSlotCapacity = Structure.new do
        # Array of range capacities where each entry is for a specific capacity type.
        attribute?(:capacities, [RangeCapacity])

        # Next page token, if there are more pages.
        attribute?(:next_page_token, String, from: "nextPageToken")

        # Resource Identifier.
        attribute?(:resource_id, String, from: "resourceId")
      end
    end
  end
end
