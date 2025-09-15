# frozen_string_literal: true

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # The error response schema for the `getRangeSlotCapacity` operation.
      RangeSlotCapacityErrors = Structure.new do
        # @return [Array<Error>] Errors encountered during the `getRangeSlotCapacity` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
