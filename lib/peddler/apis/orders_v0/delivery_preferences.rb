# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class OrdersV0
      # Contains all of the delivery instructions provided by the customer for the shipping address.
      DeliveryPreferences = Structure.new do
        # @return [String] Building instructions, nearby landmark or navigation instructions.
        attribute?(:address_instructions, String, from: "AddressInstructions")

        # @return [String] Drop-off location selected by the customer.
        attribute?(:drop_off_location, String, from: "DropOffLocation")

        # @return [Array<OtherDeliveryAttributes>] Enumerated list of miscellaneous delivery attributes associated with
        # the shipping address.
        attribute?(:other_attributes, Array, from: "OtherAttributes")

        # @return [PreferredDeliveryTime] Business hours and days when the delivery is preferred.
        attribute?(:preferred_delivery_time, PreferredDeliveryTime, from: "PreferredDeliveryTime")
      end
    end
  end
end
