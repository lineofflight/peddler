# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SalesV1
      # Contains order metrics.
      OrderMetricsInterval = Structure.new do
        # @return [Money] The average price for an item based on the specified filters. Formula is totalSales/unitCount.
        attribute(:average_unit_price, Money, from: "averageUnitPrice")

        # @return [String] The interval of time based on requested granularity (ex. Hour, Day, etc.) If this is the
        #   first or the last interval from the list, it might contain incomplete data if the requested interval doesn't
        #   align with the requested granularity (ex. request interval 2018-09-01T02:00:00Z--2018-09-04T19:00:00Z and
        #   granularity day will result in Sept 1st UTC day and Sept 4th UTC days having partial data).
        attribute(:interval, String)

        # @return [Integer] The number of orders based on the specified filters.
        attribute(:order_count, Integer, from: "orderCount")

        # @return [Integer] The number of order items based on the specified filters.
        attribute(:order_item_count, Integer, from: "orderItemCount")

        # @return [Money] The total ordered product sales for all orders based on the specified filters.
        attribute(:total_sales, Money, from: "totalSales")

        # @return [Integer] The number of units in orders based on the specified filters.
        attribute(:unit_count, Integer, from: "unitCount")
      end
    end
  end
end
