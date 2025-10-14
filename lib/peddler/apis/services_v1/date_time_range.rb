# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # A range of time.
      DateTimeRange = Structure.new do
        # @return [Time] The end of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:end_time, Time, from: "endTime")

        # @return [Time] The beginning of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
