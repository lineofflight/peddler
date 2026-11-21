# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # `UpdateReservationRecord` entity contains the `Reservation` if there is an error/warning while performing the
      # requested operation on it, otherwise it will contain the new `reservationId`.
      UpdateReservationRecord = Structure.new do
        # Errors encountered, if any.
        attribute?(:errors, [Error])

        # Reservation record if the operation failed. It will only contain the new `reservationId` if the operation is
        # successful.
        attribute?(:reservation, Reservation)

        # Warnings encountered, if any.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
