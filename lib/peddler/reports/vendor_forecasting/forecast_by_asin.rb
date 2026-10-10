# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorForecasting
      # Describes forecast units for a particular ASIN for a specific period of time in the future.
      ForecastByASIN = Structure.new do
        # The Amazon Standard Identification Number.
        attribute(:asin, String, null: false)

        # The end date of the time period being forecasted. The forecasted time period includes this date.
        attribute(:end_date, Date, null: false, from: "endDate")

        # The date that the forecast was generated.
        attribute(:forecast_generation_date, Date, null: false, from: "forecastGenerationDate")

        # The average amount of forecast units that Amazon has predicted for this date range. This means that, on
        # average, Amazon predicts that this many stock units will be purchased during this date range.
        attribute(:mean_forecast_units, Float, null: false, from: "meanForecastUnits")

        # The 70th percentile of forecast units that Amazon has predicted for this date range. This means that Amazon
        # has forecasted a 70% probability that the ASIN will not run out of stock during the date range if this many
        # units of inventory are present at the start of the date range.
        attribute(:p70_forecast_units, Float, null: false, from: "p70ForecastUnits")

        # The 80th percentile of forecast units that Amazon has predicted for this date range. This means that Amazon
        # has forecasted an 80% probability that the ASIN will not run out of stock during the date range if this many
        # units of inventory are present at the start of the date range.
        attribute(:p80_forecast_units, Float, null: false, from: "p80ForecastUnits")

        # The 90th percentile of forecast units that Amazon has predicted for this date range. This means that Amazon
        # has forecasted a 90% probability that the ASIN will not run out of stock during the date range if this many
        # units of inventory are present at the start of the date range.
        attribute(:p90_forecast_units, Float, null: false, from: "p90ForecastUnits")

        # The start date of the time period being forecasted. The forecasted time period includes this date.
        attribute(:start_date, Date, null: false, from: "startDate")
      end
    end
  end
end
