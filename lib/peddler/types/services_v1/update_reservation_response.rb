# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/update_reservation_record"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `updateReservation` operation.
      UpdateReservationResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [UpdateReservationRecord] `UpdateReservationRecord` contains only the new `reservationId` if the
        # operation was successful. Otherwise it will contain the reservation entity with warnings/errors.
        attribute?(:payload, UpdateReservationRecord)
      end
    end
  end
end
