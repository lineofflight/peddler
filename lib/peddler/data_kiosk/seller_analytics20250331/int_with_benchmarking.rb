# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # A custom type which supports time range benchmarking for native Int types.
      IntWithBenchmarking = Structure.new do
        # @return [TimeRangeBenchmarking]
        attribute?(:time_range_benchmarking, TimeRangeBenchmarking, from: "timeRangeBenchmarking")

        # @return [Integer]
        attribute?(:value, Integer, null: false)
      end
    end
  end
end
