# frozen_string_literal: true

require "peddler/types/shipping_v2/package_document_detail"
require "peddler/types/shipping_v2/promise"
require "peddler/types/shipping_v2/carrier"
require "peddler/types/shipping_v2/service"
require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # The payload for the OneClickShipment API.
      OneClickShipmentResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Array<PackageDocumentDetail>]
        attribute(:package_document_details, [PackageDocumentDetail], from: "packageDocumentDetails")

        # @return [Promise]
        attribute(:promise, Promise)

        # @return [Carrier]
        attribute(:carrier, Carrier)

        # @return [Service]
        attribute(:service, Service)

        # @return [Currency]
        attribute(:total_charge, Currency, from: "totalCharge")
      end
    end
  end
end
