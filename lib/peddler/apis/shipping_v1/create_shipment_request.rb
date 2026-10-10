# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The request schema for the createShipment operation.
      CreateShipmentRequest = Structure.new do
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        attribute(:containers, [Container], null: false)

        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute(:ship_to, Address, null: false, from: "shipTo")
      end
    end
  end
end
