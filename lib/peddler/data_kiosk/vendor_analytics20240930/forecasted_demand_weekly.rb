# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Forecasted customer demand by week. A null value for a given metric means that the metric is not available.
      ForecastedDemandWeekly = Structure.new do
        # Amazon's estimate that customer demand will be at or below this value.
        attribute?(:demand, ForecastedDemandStatistic)

        # End date of the forecasting range.
        attribute?(:end_date, String, null: false, from: "endDate")

        # Start date of the forecasting range.
        attribute?(:start_date, String, null: false, from: "startDate")

        # Week number of the forecasting range.
        attribute?(:week_number, Integer, null: false, from: "weekNumber")
      end
    end
  end
end
