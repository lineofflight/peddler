# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Contains all delivery instructions that the customer provides for the shipping address.
      DeliveryPreference = Structure.new do
        # @return [String] Building instructions, nearby landmark, or navigation instructions.
        attribute?(:address_instruction, String, from: "addressInstruction")

        # @return [Array<PreferredDeliveryCapability>] A list of miscellaneous delivery capabilities associated with the
        #   shipping address.
        attribute?(:delivery_capabilities, Array, from: "deliveryCapabilities")

        # @return [PreferredDeliveryTime] Business hours and days when the delivery is preferred.
        attribute?(:delivery_time, PreferredDeliveryTime, from: "deliveryTime")

        # @return [String] The drop-off location selected by the customer.
        attribute?(:drop_off_location, String, from: "dropOffLocation")
      end
    end
  end
end
