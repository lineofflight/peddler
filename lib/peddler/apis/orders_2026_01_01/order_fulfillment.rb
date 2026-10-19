# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Orders20260101
      # Information about how the order is being processed, packed, and shipped to the customer.
      OrderFulfillment = Structure.new do
        # The current status of the order in the fulfillment process, from pending to handover to carrier. Known values:
        # `PENDING_AVAILABILITY`, `PENDING`, `UNSHIPPED`, `PARTIALLY_SHIPPED`, `SHIPPED`, `CANCELLED`, `UNFULFILLABLE`.
        attribute(:fulfillment_status, String, null: false, from: "fulfillmentStatus")

        # The promised time period within which the order should be delivered to the customer.
        attribute?(:deliver_by_window, DateTimeRange, from: "deliverByWindow")

        # Specifies whether Amazon or the merchant is responsible for fulfilling this order.
        #
        # **Possible values**: `AMAZON`, `MERCHANT`.
        attribute?(:fulfilled_by, String, from: "fulfilledBy")

        # The category of the shipping speed option selected by the customer at checkout.
        #
        # **Possible values**: `EXPEDITED`, `FREE_ECONOMY`, `NEXT_DAY`, `PRIORITY`, `SAME_DAY`, `SECOND_DAY`,
        # `SCHEDULED`, `STANDARD`.
        attribute?(:fulfillment_service_level, String, from: "fulfillmentServiceLevel")

        # The earliest time available to print the shipping label for the order. Printing is available any time after
        # the earliestDateTime. Response does not include a latestDateTime.
        #
        # Note: If blank, printing is available at any time.
        attribute?(:label_printing_window, DateTimeRange, from: "labelPrintingWindow")

        # The inputs used to calculate a promise date for this order.
        attribute?(:promise_calculation_inputs, PromiseCalculationInputs, from: "promiseCalculationInputs")

        # The promised time period within which the order must be shipped to meet the customer's delivery expectations.
        attribute?(:ship_by_window, DateTimeRange, from: "shipByWindow")
      end
    end
  end
end
