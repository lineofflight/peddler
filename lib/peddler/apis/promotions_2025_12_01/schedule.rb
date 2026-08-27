# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Promotions20251201
      # A promotion's start and end dates with optional event association.
      Schedule = Structure.new do
        # @return [Time] The promotion's end date and time. Formatted in ISO 8601 format, including the timezone. For
        #   example: `1970-01-01T00:00:00-07:00`.
        attribute?(:end_date, Time, from: "endDate")

        # @return [String] An event identifier that associates the promotion with a specific event. For event
        #   promotions, this field contains the event name when available (for example, `Prime Day`). For historic event
        #   promotions, this field may contain `EVENT` as a placeholder.
        attribute?(:event_id, String, from: "eventId")

        # @return [Time] The promotion's start date and time. Formatted in ISO 8601 format, including the timezone. For
        #   example: `1970-01-01T00:00:00-07:00`.
        attribute?(:start_date, Time, from: "startDate")
      end
    end
  end
end
