# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information related to time range for transaction.
      TimeRangeContext = Structure.new do
        # @return [String] End time of the transaction.
        attribute?(:end_time, String, from: "endTime")

        # @return [String] Start time of the transaction.
        attribute?(:start_time, String, from: "startTime")
      end
    end
  end
end
