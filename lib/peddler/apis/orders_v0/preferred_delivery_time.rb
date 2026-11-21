# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module OrdersV0
      # The time window when the delivery is preferred.
      PreferredDeliveryTime = Structure.new do
        # Business hours when the business is open for deliveries.
        attribute?(:business_hours, [BusinessHours], from: "BusinessHours")

        # Dates when the business is closed during the next 30 days.
        attribute?(:exception_dates, [ExceptionDates], from: "ExceptionDates")
      end
    end
  end
end
