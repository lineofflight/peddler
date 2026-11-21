# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Request schema for the `updateReservation` operation.
      UpdateReservationRequest = Structure.new do
        # `Reservation` object to reduce the capacity of a resource.
        attribute(:reservation, Reservation, null: false)

        # Resource (store) identifier.
        attribute(:resource_id, String, null: false, from: "resourceId")
      end
    end
  end
end
