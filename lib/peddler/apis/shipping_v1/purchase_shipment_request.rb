# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        # @return [String]
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        # @return [Array<Container>]
        attribute(:containers, [Container], null: false)

        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, null: false, from: "labelSpecification")

        # @return [String]
        attribute(:service_type, String, null: false, from: "serviceType")

        # @return [Address]
        attribute(:ship_from, Address, null: false, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, null: false, from: "shipTo")

        # @return [Time] The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")
      end
    end
  end
end
