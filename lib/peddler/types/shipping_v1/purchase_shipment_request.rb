# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/container"
require "peddler/types/shipping_v1/label_specification"
require "peddler/types/shipping_v1/address"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container])

        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")

        # @return [String]
        attribute(:service_type, String, from: "serviceType")

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [String] The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, String, from: "shipDate")
      end
    end
  end
end
