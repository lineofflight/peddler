# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/reservation"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `createReservation` operation.
      CreateReservationRequest = Structure.new do
        # @return [String] Resource (store) identifier.
        attribute(:resource_id, String, from: "resourceId")

        # @return [Reservation] `Reservation` object to reduce the capacity of a resource.
        attribute(:reservation, Reservation)
      end
    end
  end
end
