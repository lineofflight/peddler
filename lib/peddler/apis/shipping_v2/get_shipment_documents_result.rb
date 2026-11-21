# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The payload for the getShipmentDocuments operation.
      GetShipmentDocumentsResult = Structure.new do
        attribute(:package_document_detail, PackageDocumentDetail, null: false, from: "packageDocumentDetail")

        attribute(:shipment_id, String, null: false, from: "shipmentId")

        attribute?(:benefits, Benefits)
      end
    end
  end
end
