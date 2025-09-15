# frozen_string_literal: true

require "peddler/types/services_v1/availability_record"

module Peddler
  module Types
    module ServicesV1
      # Reservation object reduces the capacity of a resource.
      Reservation = Structure.new do
        # @return [String] Unique identifier for a reservation. If present, it is treated as an update reservation
        # request and will update the corresponding reservation. Otherwise, it is treated as a new create reservation
        # request.
        attribute(:reservation_id, String, from: "reservationId")

        # @return [String] Type of reservation.
        attribute(:type, String)

        # @return [AvailabilityRecord] `AvailabilityRecord` to represent the capacity of a resource over a time range.
        attribute(:availability, AvailabilityRecord)
      end
    end
  end
end
