# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Information for tracking package deliveries.
      TrackingEvent = Structure.new do
        # @return [TrackingAddress] The city where the delivery event took place.
        attribute(:event_address, TrackingAddress, null: false, from: "eventAddress")

        # @return [String] The event code for the delivery event. Known values: `EVENT_101`, `EVENT_102`, `EVENT_201`,
        #   `EVENT_202`, `EVENT_203`, `EVENT_204`, `EVENT_205`, `EVENT_206`, `EVENT_301`, `EVENT_302`, `EVENT_304`,
        #   `EVENT_306`, `EVENT_307`, `EVENT_308`, `EVENT_309`, `EVENT_401`, `EVENT_402`, `EVENT_403`, `EVENT_404`,
        #   `EVENT_405`, `EVENT_406`, `EVENT_407`, `EVENT_408`, `EVENT_409`, `EVENT_411`, `EVENT_412`, `EVENT_413`,
        #   `EVENT_414`, `EVENT_415`, `EVENT_416`, `EVENT_417`, `EVENT_418`, `EVENT_419`, `EVENT_801`, `EVENT_804`.
        attribute(:event_code, String, null: false, from: "eventCode")

        # @return [String] The date and time that the delivery event took place, in ISO 8601 date time format.
        attribute(:event_date, String, null: false, from: "eventDate")

        # @return [String] A description for the corresponding event code.
        attribute(:event_description, String, null: false, from: "eventDescription")
      end
    end
  end
end
