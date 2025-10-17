# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SalesAndTraffic20231115
      # A root type for Analytics Sales and Traffic queries version 2023_11_15.
      AnalyticsSalesandtraffic20231115 = Structure.new do
        # @return [Array<SalesAndTrafficByAsin>] A query to retrieve sales and traffic data for the seller's account
        #   aggregated by ASIN.
        attribute?(:sales_and_traffic_by_asin, [SalesAndTrafficByASIN], from: "salesAndTrafficByAsin")

        # @return [Array<SalesAndTrafficByDate>] A query to retrieve sales and traffic data for the seller's account
        #   aggregated by date.
        attribute?(:sales_and_traffic_by_date, [SalesAndTrafficByDate], from: "salesAndTrafficByDate")
      end
    end
  end
end
