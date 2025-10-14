# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrdersV1
      # Dates for the scheduled delivery shipments.
      ScheduledDeliveryShipment = Structure.new do
        # @return [Time] Earliest nominated delivery date for the scheduled delivery.
        attribute?(:earliest_nominated_delivery_date, Time, from: "earliestNominatedDeliveryDate")

        # @return [Time] Latest nominated delivery date for the scheduled delivery.
        attribute?(:latest_nominated_delivery_date, Time, from: "latestNominatedDeliveryDate")

        # @return [String] Scheduled delivery service type.
        attribute?(:scheduled_delivery_service_type, String, from: "scheduledDeliveryServiceType")
      end
    end
  end
end
