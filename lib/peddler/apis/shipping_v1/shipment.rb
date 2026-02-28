# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The shipment related data.
      Shipment = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container], null: false)

        # @return [Address]
        attribute(:ship_from, Address, null: false, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, null: false, from: "shipTo")

        # @return [String]
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [AcceptedRate]
        attribute?(:accepted_rate, AcceptedRate, from: "acceptedRate")

        # @return [Party]
        attribute?(:shipper, Party)
      end
    end
  end
end
