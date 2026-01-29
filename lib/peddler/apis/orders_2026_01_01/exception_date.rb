# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Special dates when normal business hours are modified or suspended, requiring different delivery scheduling.
      ExceptionDate = Structure.new do
        # @return [Date] Specific calendar date when normal operating hours do not apply. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format at day granularity.
        attribute?(:exception_date, Date, from: "exceptionDate")

        # @return [String] Operational status of the business on the specified exception date.
        attribute?(:exception_date_type, String, from: "exceptionDateType")

        # @return [Array<TimeWindow>] Alternative operating hours that apply specifically to this exception date.
        attribute?(:time_windows, [TimeWindow], from: "timeWindows")
      end
    end
  end
end
