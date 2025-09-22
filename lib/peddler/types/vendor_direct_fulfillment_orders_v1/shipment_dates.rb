# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # Shipment dates.
      ShipmentDates = Structure.new do
        # @return [String] Time by which the vendor is required to ship the order.
        attribute(:required_ship_date, String, from: "requiredShipDate")

        # @return [String] Delivery date promised to the Amazon customer.
        attribute(:promised_delivery_date, String, from: "promisedDeliveryDate")
      end
    end
  end
end
