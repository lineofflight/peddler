# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # The error response schema for the `getRangeSlotCapacity` operation.
      RangeSlotCapacityErrors = Structure.new do
        # @return [Array<Error>] Errors encountered during the `getRangeSlotCapacity` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
