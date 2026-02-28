# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The request schema for the createShipment operation.
      CreateShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container], null: false)

        # @return [Address]
        attribute(:ship_from, Address, null: false, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, null: false, from: "shipTo")
      end
    end
  end
end
