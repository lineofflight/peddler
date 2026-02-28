# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the OneClickShipment API.
      OneClickShipmentResult = Structure.new do
        # @return [Carrier]
        attribute(:carrier, Carrier, null: false)

        # @return [Array<PackageDocumentDetail>]
        attribute(:package_document_details, [PackageDocumentDetail], null: false, from: "packageDocumentDetails")

        # @return [Promise]
        attribute(:promise, Promise, null: false)

        # @return [Service]
        attribute(:service, Service, null: false)

        # @return [String]
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [Money]
        attribute(:total_charge, Money, null: false, from: "totalCharge")
      end
    end
  end
end
