# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Customer-specified time preferences for when deliveries should be attempted at the destination address.
      PreferredDeliveryTime = Structure.new do
        # @return [Array<BusinessHour>] Business hours when the business is open for deliveries.
        attribute?(:business_hours, [BusinessHour], from: "businessHours")

        # @return [Array<ExceptionDate>] Specific dates within the next 30 days when normal business hours do not apply.
        attribute?(:exception_dates, [ExceptionDate], from: "exceptionDates")
      end
    end
  end
end
