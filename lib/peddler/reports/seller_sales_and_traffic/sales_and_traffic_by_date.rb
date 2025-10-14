# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing sales and traffic metrics for ASINs in the seller's account aggregated by date.
      SalesAndTrafficByDate = Structure.new do
        # @return [Date] The start date of the period of the aggregated data.
        attribute(:date, Date)

        # @return [SalesByDate] Object describing sales metrics for ASINs in the seller's account aggregated by date.
        attribute(:sales_by_date, SalesByDate, from: "salesByDate")

        # @return [TrafficByDate] Object describing traffic metrics for ASINs in the seller's account aggregated by
        # date.
        attribute(:traffic_by_date, TrafficByDate, from: "trafficByDate")
      end
    end
  end
end
