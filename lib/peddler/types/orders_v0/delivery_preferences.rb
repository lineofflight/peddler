# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/preferred_delivery_time"

module Peddler
  module Types
    module OrdersV0
      # Contains all of the delivery instructions provided by the customer for the shipping address.
      DeliveryPreferences = Structure.new do
        # @return [String] Drop-off location selected by the customer.
        attribute?(:drop_off_location, String, from: "DropOffLocation")

        # @return [PreferredDeliveryTime] Business hours and days when the delivery is preferred.
        attribute?(:preferred_delivery_time, PreferredDeliveryTime, from: "PreferredDeliveryTime")

        # @return [Array<OtherDeliveryAttributes>] Enumerated list of miscellaneous delivery attributes associated with
        # the shipping address.
        attribute?(:other_attributes, Array, from: "OtherAttributes")

        # @return [String] Building instructions, nearby landmark or navigation instructions.
        attribute?(:address_instructions, String, from: "AddressInstructions")
      end
    end
  end
end
