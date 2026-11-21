# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        attribute(:containers, [Container], null: false)

        attribute(:label_specification, LabelSpecification, null: false, from: "labelSpecification")

        # Known values: `Amazon Shipping Ground`, `Amazon Shipping Standard`, `Amazon Shipping Premium`.
        attribute(:service_type, String, null: false, from: "serviceType")

        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute(:ship_to, Address, null: false, from: "shipTo")

        # The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")
      end
    end
  end
end
