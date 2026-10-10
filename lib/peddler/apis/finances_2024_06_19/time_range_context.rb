# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Additional information that is related to the time range of the transaction.
      TimeRangeContext = Structure.new do
        # The end time of the transaction.
        attribute?(:end_time, String, from: "endTime")

        # The start time of the transaction.
        attribute?(:start_time, String, from: "startTime")
      end
    end
  end
end
