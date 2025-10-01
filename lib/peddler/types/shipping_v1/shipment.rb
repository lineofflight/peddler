# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/container"
require "peddler/types/shipping_v1/address"
require "peddler/types/shipping_v1/accepted_rate"
require "peddler/types/shipping_v1/party"

module Peddler
  module Types
    module ShippingV1
      # The shipment related data.
      Shipment = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container])

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [AcceptedRate]
        attribute?(:accepted_rate, AcceptedRate, from: "acceptedRate")

        # @return [Party]
        attribute?(:shipper, Party)
      end
    end
  end
end
