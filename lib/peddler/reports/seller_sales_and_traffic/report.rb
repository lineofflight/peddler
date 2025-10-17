# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # This report shares data on the sales performance and page traffic of the seller's items aggregated by date
      # (across the seller's entire catalog of items) and aggregated by ASIN. Aggregated data is available at different
      # date range aggregation levels: DAY, WEEK, MONTH. Per-ASIN data is available at different ASIN aggregation
      # levels: PARENT, CHILD, SKU. Requests can span multiple date range periods.
      Report = Structure.new do
        # @return [Hash] Report summary including specified reporting date range, dateGranularity, and asinGranularity
        #   in the input.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")

        # @return [Array<SalesAndTrafficByAsin>]
        attribute(:sales_and_traffic_by_asin, [SalesAndTrafficByASIN], from: "salesAndTrafficByAsin")

        # @return [Array<SalesAndTrafficByDate>]
        attribute(:sales_and_traffic_by_date, [SalesAndTrafficByDate], from: "salesAndTrafficByDate")
      end
    end
  end
end
