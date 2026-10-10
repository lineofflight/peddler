# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module OrdersV0
      # Contains all of the delivery instructions provided by the customer for the shipping address.
      DeliveryPreferences = Structure.new do
        # Building instructions, nearby landmark or navigation instructions.
        attribute?(:address_instructions, String, from: "AddressInstructions")

        # Drop-off location selected by the customer.
        attribute?(:drop_off_location, String, from: "DropOffLocation")

        # Enumerated list of miscellaneous delivery attributes associated with the shipping address.
        attribute?(:other_attributes, Array, from: "OtherAttributes")

        # Business hours and days when the delivery is preferred.
        attribute?(:preferred_delivery_time, PreferredDeliveryTime, from: "PreferredDeliveryTime")
      end
    end
  end
end
