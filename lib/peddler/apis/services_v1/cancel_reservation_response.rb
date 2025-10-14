# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `cancelReservation` operation.
      CancelReservationResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any
        attribute?(:errors, [Error])
      end
    end
  end
end
