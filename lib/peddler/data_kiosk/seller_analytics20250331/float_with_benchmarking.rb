# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # A custom type which supports time range benchmarking for native Float types.
      FloatWithBenchmarking = Structure.new do
        attribute?(:time_range_benchmarking, TimeRangeBenchmarking, from: "timeRangeBenchmarking")

        attribute?(:value, Float, null: false)
      end
    end
  end
end
