# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # A time period with start and end boundaries.
      DateTimeRange = Structure.new do
        # @return [Time] The beginning of the time period, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:earliest_date_time, Time, from: "earliestDateTime")

        # @return [Time] The end of the time period, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:latest_date_time, Time, from: "latestDateTime")
      end
    end
  end
end
