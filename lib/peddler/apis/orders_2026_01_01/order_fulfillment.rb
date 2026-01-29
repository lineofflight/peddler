# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Information about how the order is being processed, packed, and shipped to the customer.
      OrderFulfillment = Structure.new do
        # @return [String] The current status of the order in the fulfillment process, from pending to handover to
        #   carrier.
        attribute(:fulfillment_status, String, from: "fulfillmentStatus")

        # @return [DateTimeRange] The promised time period within which the order should be delivered to the customer.
        attribute?(:deliver_by_window, DateTimeRange, from: "deliverByWindow")

        # @return [String] Specifies whether Amazon or the merchant is responsible for fulfilling this order.
        #
        # **Possible values**: `AMAZON`, `MERCHANT`.
        attribute?(:fulfilled_by, String, from: "fulfilledBy")

        # @return [String] The category of the shipping speed option selected by the customer at checkout.
        #
        # **Possible values**: `EXPEDITED`, `FREE_ECONOMY`, `NEXT_DAY`, `PRIORITY`, `SAME_DAY`, `SECOND_DAY`,
        #   `SCHEDULED`, `STANDARD`.
        attribute?(:fulfillment_service_level, String, from: "fulfillmentServiceLevel")

        # @return [DateTimeRange] The promised time period within which the order must be shipped to meet the customer's
        #   delivery expectations.
        attribute?(:ship_by_window, DateTimeRange, from: "shipByWindow")
      end
    end
  end
end
