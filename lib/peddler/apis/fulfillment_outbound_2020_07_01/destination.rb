# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The destination for the delivery offer.
      Destination = Structure.new do
        # @return [VariablePrecisionAddress]
        attribute?(:delivery_address, VariablePrecisionAddress, from: "deliveryAddress")

        # @return [String] The IP address of the customer.
        attribute?(:ip_address, String, from: "ipAddress")
      end
    end
  end
end
