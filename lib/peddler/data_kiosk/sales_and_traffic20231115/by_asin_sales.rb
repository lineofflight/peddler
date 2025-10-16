# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20231115
      # The sales data for the seller's account aggregated by ASIN.
      ByASINSales = Structure.new do
        # @return [Amount] The amount of ordered product sales, calculated by multiplying the price of
        # products and the number of units sold for the selected time period.
        attribute?(:ordered_product_sales, Amount, from: "orderedProductSales")

        # @return [Amount] The amount of ordered product sales to Amazon Business customers, calculated
        # by multiplying the price of products and the number of units sold for the
        # selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Amount, from: "orderedProductSalesB2B")

        # @return [String] The number of items that were ordered for the selected time period.
        attribute?(:total_order_items, String, from: "totalOrderItems")

        # @return [String] The number of items that were ordered by Amazon Business customers for the
        # selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:total_order_items_b2b, String, from: "totalOrderItemsB2B")

        # @return [String] The number of units ordered.
        attribute?(:units_ordered, String, from: "unitsOrdered")

        # @return [String] The number of units ordered by Amazon Business customers. Note: This field is
        # only populated when the seller is a B2B seller.
        attribute?(:units_ordered_b2b, String, from: "unitsOrderedB2B")
      end
    end
  end
end
