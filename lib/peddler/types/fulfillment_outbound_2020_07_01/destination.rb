# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/variable_precision_address"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The destination for the delivery offer.
      Destination = Structure.new do
        # @return [VariablePrecisionAddress]
        attribute(:delivery_address, VariablePrecisionAddress, from: "deliveryAddress")

        # @return [String] The IP address of the customer.
        attribute(:ip_address, String, from: "ipAddress")
      end
    end
  end
end
