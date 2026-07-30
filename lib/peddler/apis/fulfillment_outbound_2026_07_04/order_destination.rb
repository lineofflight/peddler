# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The destination of the fulfillment order.
      OrderDestination = Structure.new do
        # @return [Address]
        attribute(:delivery_address, Address, null: false, from: "deliveryAddress")

        # @return [String] Delivery notes for the fulfillment order.
        attribute?(:delivery_notes, String, from: "deliveryNotes")

        # @return [OrderDropOffLocation] Drop-off location for the fulfillment order.
        attribute?(:drop_off_location, OrderDropOffLocation, from: "dropOffLocation")
      end
    end
  end
end
