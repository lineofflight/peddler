# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Support20250201
      # The time window for an appointment callback
      CallbackTiming = Structure.new do
        # @return [Time] The earliest time at which to call the selling partner.
        attribute(:earliest_callback_time, Time, null: false, from: "earliestCallbackTime")

        # @return [Time] The latest time at which to call the selling partner.
        attribute(:latest_callback_time, Time, null: false, from: "latestCallbackTime")
      end
    end
  end
end
