# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/container"
require "peddler/types/shipping_v1/address"

module Peddler
  module Types
    module ShippingV1
      # The request schema for the createShipment operation.
      CreateShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container])

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")
      end
    end
  end
end
