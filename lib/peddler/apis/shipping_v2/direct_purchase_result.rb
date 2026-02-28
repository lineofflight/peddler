# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the directPurchaseShipment operation.
      DirectPurchaseResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [Array<PackageDocumentDetail>]
        attribute?(:package_document_detail_list, [PackageDocumentDetail], from: "packageDocumentDetailList")
      end
    end
  end
end
