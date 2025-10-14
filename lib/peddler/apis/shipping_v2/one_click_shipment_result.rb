# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the OneClickShipment API.
      OneClickShipmentResult = Structure.new do
        # @return [Carrier]
        attribute(:carrier, Carrier)

        # @return [Array<PackageDocumentDetail>]
        attribute(:package_document_details, [PackageDocumentDetail], from: "packageDocumentDetails")

        # @return [Promise]
        attribute(:promise, Promise)

        # @return [Service]
        attribute(:service, Service)

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Money]
        attribute(:total_charge, Money, from: "totalCharge")
      end
    end
  end
end
