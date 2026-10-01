# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Monetary amount with the corresponding currency code and time range benchmarking.
      AmountWithBenchmarking = Structure.new do
        # @return [Amount] The monetary amount and its currency code, in ISO 4217 format.
        attribute?(:amount, Amount, null: false)

        # @return [TimeRangeBenchmarking] Relevant benchmarking comparison.
        attribute?(:time_range_benchmarking, TimeRangeBenchmarking, from: "timeRangeBenchmarking")
      end
    end
  end
end
