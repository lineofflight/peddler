# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/invoice_requirement"
require "peddler/types/external_fulfillment_shipments_2024_09_11/packing_slip_requirement"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Whether specific capabilities are enabled or required for the shipment.
      ShipmentRequirements = Structure.new do
        # @return [InvoiceRequirement] Whether the invoice must be attached to the shipment.
        attribute(:invoice, InvoiceRequirement)

        # @return [PackingSlipRequirement] Whether the packing slip must be attached to the shipment.
        attribute(:p_slip, PackingSlipRequirement, from: "pSlip")
      end
    end
  end
end
