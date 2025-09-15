# frozen_string_literal: true

require "peddler/types/shipping_v2/package_document_detail"
require "peddler/types/shipping_v2/promise"
require "peddler/types/shipping_v2/benefits"

module Peddler
  module Types
    module ShippingV2
      # The payload for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Array<PackageDocumentDetail>]
        attribute(:package_document_details, [PackageDocumentDetail], from: "packageDocumentDetails")

        # @return [Promise]
        attribute(:promise, Promise)

        # @return [Benefits]
        attribute(:benefits, Benefits)
      end
    end
  end
end
