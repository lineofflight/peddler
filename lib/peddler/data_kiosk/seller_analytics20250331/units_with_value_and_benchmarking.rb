# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Number of units with their corresponding monetary value and time range benchmarking.
      UnitsWithValueAndBenchmarking = Structure.new do
        # @return [TimeRangeBenchmarking] Relevant time range benchmarking comparison for units.
        attribute?(:units_time_range_benchmarking, TimeRangeBenchmarking, from: "unitsTimeRangeBenchmarking")

        # @return [UnitsWithValue] Number of units and monetary value of the units.
        attribute?(:units_with_value, UnitsWithValue, null: false, from: "unitsWithValue")

        # @return [TimeRangeBenchmarking] Relevant time range benchmarking of the monetary value of units.
        attribute?(:value_time_range_benchmarking, TimeRangeBenchmarking, from: "valueTimeRangeBenchmarking")
      end
    end
  end
end
