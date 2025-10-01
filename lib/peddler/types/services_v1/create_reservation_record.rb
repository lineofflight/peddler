# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/reservation"
require "peddler/types/services_v1/warning"

module Peddler
  module Types
    module ServicesV1
      # `CreateReservationRecord` entity contains the `Reservation` if there is an error/warning while performing the
      # requested operation on it, otherwise it will contain the new `reservationId`.
      CreateReservationRecord = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [Reservation] Reservation record if the operation failed. It will only contain the new `reservationId`
        # if the operation is successful.
        attribute?(:reservation, Reservation)

        # @return [Array<Warning>] Warnings encountered, if any.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
