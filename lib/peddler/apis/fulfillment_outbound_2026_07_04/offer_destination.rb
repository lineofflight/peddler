# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The destination of the fulfillment.
      OfferDestination = Structure.new do
        attribute?(:delivery_address, VariablePrecisionAddress, from: "deliveryAddress")

        # The IP address of the customer.
        attribute?(:ip_address, String, from: "ipAddress")
      end
    end
  end
end
