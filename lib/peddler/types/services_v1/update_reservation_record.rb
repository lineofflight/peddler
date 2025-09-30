# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/reservation"
require "peddler/types/services_v1/warning"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # `UpdateReservationRecord` entity contains the `Reservation` if there is an error/warning while performing the
      # requested operation on it, otherwise it will contain the new `reservationId`.
      UpdateReservationRecord = Structure.new do
        # @return [Reservation] Reservation record if the operation failed. It will only contain the new `reservationId`
        # if the operation is successful.
        attribute?(:reservation, Reservation)

        # @return [Array<Warning>] Warnings encountered, if any.
        attribute?(:warnings, [Warning])

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])
      end
    end
  end
end
