# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Drop-off location for the fulfillment order.
      OrderDropOffLocation = Structure.new do
        # @return [Hash] Drop-off location attributes.
        attribute?(:attributes, Hash)

        # @return [String] Specifies the preferred location to leave the package at the destination address. Possible
        #   values: `FRONT_DOOR`, `DELIVERY_BOX`, `GAS_METER_BOX`, `BICYCLE_BASKET`, `GARAGE`, `RECEPTIONIST`,
        #   `FALLBACK_NEIGHBOR_DELIVERY`, `DO_NOT_LEAVE_UNATTENDED`, `LOCKER`
        attribute?(:type, String)
      end
    end
  end
end
