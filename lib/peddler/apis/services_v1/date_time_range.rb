# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # A range of time.
      DateTimeRange = Structure.new do
        # The end of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:end_time, Time, null: false, from: "endTime")

        # The beginning of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
