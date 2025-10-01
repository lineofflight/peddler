# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `cancelReservation` operation.
      CancelReservationResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any
        attribute?(:errors, [Error])
      end
    end
  end
end
