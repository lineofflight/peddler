# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/package_document_detail"
require "peddler/types/shipping_v2/benefits"

module Peddler
  module Types
    module ShippingV2
      # The payload for the getShipmentDocuments operation.
      GetShipmentDocumentsResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [PackageDocumentDetail]
        attribute(:package_document_detail, PackageDocumentDetail, from: "packageDocumentDetail")

        # @return [Benefits]
        attribute(:benefits, Benefits)
      end
    end
  end
end
