# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The shipment related data.
      Shipment = Structure.new do
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        attribute(:containers, [Container], null: false)

        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute(:ship_to, Address, null: false, from: "shipTo")

        attribute(:shipment_id, String, null: false, from: "shipmentId")

        attribute?(:accepted_rate, AcceptedRate, from: "acceptedRate")

        attribute?(:shipper, Party)
      end
    end
  end
end
