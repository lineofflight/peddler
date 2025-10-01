# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/shipping_v2/carrier"
require "peddler/types/shipping_v2/package_document_detail"
require "peddler/types/shipping_v2/promise"
require "peddler/types/shipping_v2/service"

module Peddler
  module Types
    module ShippingV2
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
