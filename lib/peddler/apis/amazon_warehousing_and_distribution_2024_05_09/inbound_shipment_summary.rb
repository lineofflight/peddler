# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Summary for an AWD inbound shipment containing the shipment ID, which can be used to retrieve the actual
      # shipment.
      InboundShipmentSummary = Structure.new do
        # @return [String] The AWD inbound order ID that this inbound shipment belongs to.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [String] A unique shipment ID.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String]
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # @return [Time] Timestamp when the shipment was created.
        attribute?(:created_at, Time, from: "createdAt")

        # @return [String] Optional client-provided reference ID that can be used to correlate this shipment with client
        #   resources. For example, to map this shipment to an internal bookkeeping order record.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # @return [Time] Timestamp when the shipment was updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
