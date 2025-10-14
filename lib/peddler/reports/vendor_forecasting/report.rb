# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorForecasting
      # Forecast customer demand of your products for production and inventory planning purposes.
      Report = Structure.new do
        # @return [Array<ForecastByAsin>]
        attribute(:forecast_by_asin, [ForecastByASIN], from: "forecastByAsin")

        # @return [Hash] The report input summary which includes the marketplace, selling program, and last updated
        # date.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
