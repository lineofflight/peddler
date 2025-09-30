# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/address"
require "peddler/types/shipping_v1/container"
require "peddler/types/shipping_v1/label_specification"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, from: "clientReferenceId")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [String] The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, String, from: "shipDate")

        # @return [String]
        attribute(:service_type, String, from: "serviceType")

        # @return [Array<Container>]
        attribute(:containers, [Container])

        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")
      end
    end
  end
end
