# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # A root type for Analytics Sales and Traffic queries version 2024_04_24.
      AnalyticsSalesandtraffic20240424 = Structure.new do
        # @return [Array<SalesAndTrafficByAsin>] A query to retrieve sales and traffic data for the seller's account
        # aggregated by ASIN.
        attribute?(:sales_and_traffic_by_asin, [SalesAndTrafficByASIN], from: "salesAndTrafficByAsin")

        # @return [Array<SalesAndTrafficByDate>] A query to retrieve sales and traffic data for the seller's account
        # aggregated by date.
        attribute?(:sales_and_traffic_by_date, [SalesAndTrafficByDate], from: "salesAndTrafficByDate")

        # @return [Array<SalesAndTrafficTrends>] This query retrieves sales and traffic trend data for a specified list
        # of
        # ASINs within a date range. The data can be aggregated at different time
        # intervals to support various analytical needs.
        attribute?(:sales_and_traffic_trends, [SalesAndTrafficTrends], from: "salesAndTrafficTrends")
      end
    end
  end
end
