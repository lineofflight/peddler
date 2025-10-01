# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/get_shipment_documents_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the the getShipmentDocuments operation.
      GetShipmentDocumentsResponse = Structure.new do
        # @return [GetShipmentDocumentsResult]
        attribute?(:payload, GetShipmentDocumentsResult)
      end
    end
  end
end
