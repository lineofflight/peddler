# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the getShipmentDocuments operation.
      GetShipmentDocumentsResult = Structure.new do
        # @return [PackageDocumentDetail]
        attribute(:package_document_detail, PackageDocumentDetail, from: "packageDocumentDetail")

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Benefits]
        attribute?(:benefits, Benefits)
      end
    end
  end
end
