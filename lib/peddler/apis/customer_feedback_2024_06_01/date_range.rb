# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # A date range.
      DateRange = Structure.new do
        # @return [Time] The end date of the date range in ISO-8601 date/time format.
        attribute(:end_date, Time, from: "endDate")

        # @return [Time] The start date of the date range in ISO-8601 date/time format.
        attribute(:start_date, Time, from: "startDate")
      end
    end
  end
end
