# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The destination for the delivery offer.
      Destination = Structure.new do
        attribute?(:delivery_address, VariablePrecisionAddress, from: "deliveryAddress")

        # The IP address of the customer.
        attribute?(:ip_address, String, from: "ipAddress")
      end
    end
  end
end
