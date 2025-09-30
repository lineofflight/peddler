# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/update_reservation_record"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `updateReservation` operation.
      UpdateReservationResponse = Structure.new do
        # @return [UpdateReservationRecord] `UpdateReservationRecord` contains only the new `reservationId` if the
        # operation was successful. Otherwise it will contain the reservation entity with warnings/errors.
        attribute?(:payload, UpdateReservationRecord)

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])
      end
    end
  end
end
