# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Forecasted customer demand by week. A null value for a given metric means that the metric is not available.
      ForecastedDemandWeekly = Structure.new do
        # @return [ForecastedDemandStatistic] Amazon's estimate that customer demand will be at or below this value.
        attribute?(:demand, ForecastedDemandStatistic)

        # @return [String] End date of the forecasting range.
        attribute?(:end_date, String, from: "endDate")

        # @return [String] Start date of the forecasting range.
        attribute?(:start_date, String, from: "startDate")

        # @return [Integer] Week number of the forecasting range.
        attribute?(:week_number, Integer, from: "weekNumber")
      end
    end
  end
end
