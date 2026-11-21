# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorForecasting
      # Forecast customer demand of your products for production and inventory planning purposes.
      Report = Structure.new do
        attribute(:forecast_by_asin, [ForecastByASIN], null: false, from: "forecastByAsin")

        # The report input summary which includes the marketplace, selling program, and last updated date.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
