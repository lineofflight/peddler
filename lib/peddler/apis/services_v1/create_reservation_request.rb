# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Request schema for the `createReservation` operation.
      CreateReservationRequest = Structure.new do
        # @return [Reservation] `Reservation` object to reduce the capacity of a resource.
        attribute(:reservation, Reservation, null: false)

        # @return [String] Resource (store) identifier.
        attribute(:resource_id, String, null: false, from: "resourceId")
      end
    end
  end
end
