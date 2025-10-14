# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # Date Range for query the results.
      DateRange = Structure.new do
        # @return [Time] end date for query.
        attribute?(:end_date, Time, from: "endDate")

        # @return [Time] Start Date for query .
        attribute?(:start_date, Time, from: "startDate")
      end
    end
  end
end
