# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional information related to time range for transaction.
      TimeRangeContext = Structure.new do
        # @return [String] Start time of the transaction.
        attribute(:start_time, String, from: "startTime")

        # @return [String] End time of the transaction.
        attribute(:end_time, String, from: "endTime")
      end
    end
  end
end
