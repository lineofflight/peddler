# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/create_reservation_record"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `createReservation` operation.
      CreateReservationResponse = Structure.new do
        # @return [CreateReservationRecord] `CreateReservationRecord` contains only the new `reservationId` if the
        # operation was successful. Otherwise it will contain the reservation entity with warnings/errors.
        attribute?(:payload, CreateReservationRecord)

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])
      end
    end
  end
end
