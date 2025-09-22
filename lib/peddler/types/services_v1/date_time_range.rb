# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # A range of time.
      DateTimeRange = Structure.new do
        # @return [String] The beginning of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:start_time, String, from: "startTime")

        # @return [String] The end of the time range. Must be in UTC in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:end_time, String, from: "endTime")
      end
    end
  end
end
