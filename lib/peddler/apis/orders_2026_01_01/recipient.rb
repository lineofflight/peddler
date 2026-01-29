# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about the recipient to whom the order should be delivered.
      Recipient = Structure.new do
        # @return [CustomerAddress] The address where the order should be delivered to the customer.
        attribute?(:delivery_address, CustomerAddress, from: "deliveryAddress")

        # @return [DeliveryPreference] Special instructions and preferences that the customer specifies for how the
        #   order should be delivered.
        attribute?(:delivery_preference, DeliveryPreference, from: "deliveryPreference")
      end
    end
  end
end
