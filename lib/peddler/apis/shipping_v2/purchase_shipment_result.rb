# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        # @return [Array<PackageDocumentDetail>]
        attribute(:package_document_details, [PackageDocumentDetail], from: "packageDocumentDetails")

        # @return [Promise]
        attribute(:promise, Promise)

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Benefits]
        attribute?(:benefits, Benefits)
      end
    end
  end
end
