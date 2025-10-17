# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # `UpdateReservationRecord` entity contains the `Reservation` if there is an error/warning while performing the
      # requested operation on it, otherwise it will contain the new `reservationId`.
      UpdateReservationRecord = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [Reservation] Reservation record if the operation failed. It will only contain the new `reservationId`
        #   if the operation is successful.
        attribute?(:reservation, Reservation)

        # @return [Array<Warning>] Warnings encountered, if any.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
