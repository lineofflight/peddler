# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The destination of the fulfillment order.
      OrderDestination = Structure.new do
        attribute(:delivery_address, Address, null: false, from: "deliveryAddress")

        # Delivery notes for the fulfillment order.
        attribute?(:delivery_notes, String, from: "deliveryNotes")

        # Drop-off location for the fulfillment order.
        attribute?(:drop_off_location, OrderDropOffLocation, from: "dropOffLocation")
      end
    end
  end
end
