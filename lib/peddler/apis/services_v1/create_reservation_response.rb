# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `createReservation` operation.
      CreateReservationResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [CreateReservationRecord] `CreateReservationRecord` contains only the new `reservationId` if the
        # operation was successful. Otherwise it will contain the reservation entity with warnings/errors.
        attribute?(:payload, CreateReservationRecord)
      end
    end
  end
end
