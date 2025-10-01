# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/reservation"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `updateReservation` operation.
      UpdateReservationRequest = Structure.new do
        # @return [Reservation] `Reservation` object to reduce the capacity of a resource.
        attribute(:reservation, Reservation)

        # @return [String] Resource (store) identifier.
        attribute(:resource_id, String, from: "resourceId")
      end
    end
  end
end
