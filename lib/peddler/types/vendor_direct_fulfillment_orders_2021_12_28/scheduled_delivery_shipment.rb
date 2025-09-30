# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Dates for the scheduled delivery shipments.
      ScheduledDeliveryShipment = Structure.new do
        # @return [String] Scheduled delivery service type.
        attribute?(:scheduled_delivery_service_type, String, from: "scheduledDeliveryServiceType")

        # @return [String] Earliest nominated delivery date for the scheduled delivery.
        attribute?(:earliest_nominated_delivery_date, String, from: "earliestNominatedDeliveryDate")

        # @return [String] Latest nominated delivery date for the scheduled delivery.
        attribute?(:latest_nominated_delivery_date, String, from: "latestNominatedDeliveryDate")
      end
    end
  end
end
