# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Shipment dates.
      ShipmentDates = Structure.new do
        # @return [Time] Time by which the vendor is required to ship the order.
        attribute(:required_ship_date, Time, from: "requiredShipDate")

        # @return [Time] Delivery date promised to the Amazon customer.
        attribute?(:promised_delivery_date, Time, from: "promisedDeliveryDate")
      end
    end
  end
end
