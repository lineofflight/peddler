# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/package_document_detail"

module Peddler
  module Types
    module ShippingV2
      # The payload for the directPurchaseShipment operation.
      DirectPurchaseResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Array<PackageDocumentDetail>]
        attribute?(:package_document_detail_list, [PackageDocumentDetail], from: "packageDocumentDetailList")
      end
    end
  end
end
