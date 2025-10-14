# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Reservation object reduces the capacity of a resource.
      Reservation = Structure.new do
        # @return [AvailabilityRecord] `AvailabilityRecord` to represent the capacity of a resource over a time range.
        attribute(:availability, AvailabilityRecord)

        # @return [String] Type of reservation.
        attribute(:type, String)

        # @return [String] Unique identifier for a reservation. If present, it is treated as an update reservation
        # request and will update the corresponding reservation. Otherwise, it is treated as a new create reservation
        # request.
        attribute?(:reservation_id, String, from: "reservationId")
      end
    end
  end
end
