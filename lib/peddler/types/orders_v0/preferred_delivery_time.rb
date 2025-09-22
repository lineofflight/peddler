# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/business_hours"
require "peddler/types/orders_v0/exception_dates"

module Peddler
  module Types
    module OrdersV0
      # The time window when the delivery is preferred.
      PreferredDeliveryTime = Structure.new do
        # @return [Array<BusinessHours>] Business hours when the business is open for deliveries.
        attribute(:business_hours, [BusinessHours], from: "BusinessHours")

        # @return [Array<ExceptionDates>] Dates when the business is closed during the next 30 days.
        attribute(:exception_dates, [ExceptionDates], from: "ExceptionDates")
      end
    end
  end
end
