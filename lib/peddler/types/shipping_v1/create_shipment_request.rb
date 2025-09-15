# frozen_string_literal: true

require "peddler/types/shipping_v1/address"
require "peddler/types/shipping_v1/container"

module Peddler
  module Types
    module ShippingV1
      # The request schema for the createShipment operation.
      CreateShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, from: "clientReferenceId")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Array<Container>]
        attribute(:containers, [Container])
      end
    end
  end
end
