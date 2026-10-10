# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The payload for the OneClickShipment API.
      OneClickShipmentResult = Structure.new do
        attribute(:carrier, Carrier, null: false)

        attribute(:package_document_details, [PackageDocumentDetail], null: false, from: "packageDocumentDetails")

        attribute(:promise, Promise, null: false)

        attribute(:service, Service, null: false)

        attribute(:shipment_id, String, null: false, from: "shipmentId")

        attribute(:total_charge, Money, null: false, from: "totalCharge")
      end
    end
  end
end
