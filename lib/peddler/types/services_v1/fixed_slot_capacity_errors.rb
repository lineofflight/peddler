# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # The error response schema for the `getFixedSlotCapacity` operation.
      FixedSlotCapacityErrors = Structure.new do
        # @return [Array<Error>] Errors encountered during the `getFixedSlotCapacity` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
