# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipment_invoicing_v0/error"
require "peddler/types/shipment_invoicing_v0/shipment_detail"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The response schema for the getShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShipmentDetail] The payload for the getShipmentDetails operation
        attribute?(:payload, ShipmentDetail)
      end
    end
  end
end
