# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Sales metric group. A null value for a given metric means that this metric is not yet available.
      Sales = Structure.new do
        # The average price per unit in the selected time period, calculated by dividing net orderedProductSales by net
        # unitsOrdered (both adjusted for cancellations).
        attribute?(:average_selling_price, AmountWithBenchmarking, from: "averageSellingPrice")

        # The average price of the units sold to Amazon Business customers, calculated by dividing the
        # orderedProductSalesB2B by unitsOrderedB2B for the selected time period. Note: This field is only populated if
        # you are a B2B seller on Amazon.
        attribute?(:average_selling_price_b2b, AmountWithBenchmarking, from: "averageSellingPriceB2B")

        # Total monetary value of all orders after promotions and discounts, excluding canceled orders.
        attribute?(:order_gms, AmountWithBenchmarking, from: "orderGMS")

        # The amount of ordered product sales, calculated by multiplying the price of products and the number of units
        # sold for the selected time period.
        attribute?(:ordered_product_sales, AmountWithBenchmarking, from: "orderedProductSales")

        # The amount of ordered product sales to Amazon Business customers, calculated by multiplying the price of
        # products and the number of units sold for the selected time period. Note: This field is only populated if you
        # are a B2B seller on Amazon.
        attribute?(:ordered_product_sales_b2b, AmountWithBenchmarking, from: "orderedProductSalesB2B")

        # The number of orders shipped in the selected time period as well as revenue generated.
        attribute?(:orders_shipped_with_revenue, UnitsWithValueAndBenchmarking, from: "ordersShippedWithRevenue")

        # The number of units ordered.
        attribute?(:units_ordered, IntWithBenchmarking, from: "unitsOrdered")

        # The number of units shipped in the selected time period.
        attribute?(:units_shipped, IntWithBenchmarking, from: "unitsShipped")

        # The number of units ordered by Amazon Business customers.
        # Note: This field is only populated if you are a B2B seller on Amazon.
        attribute?(:units_shipped_b2b, IntWithBenchmarking, from: "unitsShippedB2B")
      end
    end
  end
end
