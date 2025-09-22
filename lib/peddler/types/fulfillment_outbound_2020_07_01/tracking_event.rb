# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/tracking_address"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Information for tracking package deliveries.
      TrackingEvent = Structure.new do
        # @return [String] The date and time that the delivery event took place. Must be in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format.
        attribute(:event_date, String, from: "eventDate")

        # @return [TrackingAddress] The city where the delivery event took place.
        attribute(:event_address, TrackingAddress, from: "eventAddress")

        # @return [String] The event code for the delivery event.
        attribute(:event_code, String, from: "eventCode")

        # @return [String] A description for the corresponding event code.
        attribute(:event_description, String, from: "eventDescription")
      end
    end
  end
end
