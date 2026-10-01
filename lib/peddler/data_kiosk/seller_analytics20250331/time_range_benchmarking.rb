# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Benchmarking values applicable to WEEKLY and MONTHLY dateGranularity selections.
      # For example: WEEKLY supports two benchmarks (weekOverWeek and yearOverYear); MONTHLY supports two benchmarks
      # (monthOverMonth and yearOverYear).
      TimeRangeBenchmarking = Structure.new do
        # @return [Float] A metric that compares data from the current month to the previous month to measure
        #   performance changes.
        attribute?(:month_over_month, Float, from: "monthOverMonth")

        # @return [Float] A metric that compares data from the current week to the previous week to measure performance
        #   changes.
        attribute?(:week_over_week, Float, from: "weekOverWeek")

        # @return [Float] A metric that compares data from the current period to the same period last year to measure
        #   performance changes.
        attribute?(:year_over_year, Float, from: "yearOverYear")
      end
    end
  end
end
