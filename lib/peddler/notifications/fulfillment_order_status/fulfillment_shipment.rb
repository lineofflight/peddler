# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      FulfillmentShipment = Structure.new do
        # @return [String]
        attribute(:amazon_shipment_id, String, null: false, from: "AmazonShipmentId")

        # @return [String]
        attribute(:estimated_arrival_date_time, String, null: false, from: "EstimatedArrivalDateTime")

        # @return [Array]
        attribute(:fulfillment_shipment_packages, Array, null: false, from: "FulfillmentShipmentPackages")

        # @return [String]
        attribute(:fulfillment_shipment_status, String, null: false, from: "FulfillmentShipmentStatus")
      end
    end
  end
end
