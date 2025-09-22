# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipment_invoicing_v0/shipment_detail"
require "peddler/types/shipment_invoicing_v0/error"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The response schema for the getShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        # @return [ShipmentDetail] The payload for the getShipmentDetails operation
        attribute(:payload, ShipmentDetail)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
