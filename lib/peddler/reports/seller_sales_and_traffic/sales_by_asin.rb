# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing sales and traffic metrics for ASINs in the seller's account aggregated by ASIN.
      SalesByASIN = Structure.new do
        # @return [Money] The amount of ordered product sales, calculated by multiplying the price of products and the
        #   number of units sold for the selected time period.
        attribute(:ordered_product_sales, Money, null: false, from: "orderedProductSales")

        # @return [Integer] The number of items that were ordered for the selected time period.
        attribute(:total_order_items, Integer, null: false, from: "totalOrderItems")

        # @return [Integer] The number of units ordered.
        attribute(:units_ordered, Integer, null: false, from: "unitsOrdered")

        # @return [Money] The amount of ordered product sales to Amazon Business customers, calculated by multiplying
        #   the price of products and the number of units sold for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Money, from: "orderedProductSalesB2B")

        # @return [Integer] The number of items that were ordered by Amazon Business customers for the selected time
        #   period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:total_order_items_b2b, Integer, from: "totalOrderItemsB2B")

        # @return [Integer] The number of units ordered by Amazon Business customers. Note: This field is only populated
        #   when the seller is a B2B seller.
        attribute?(:units_ordered_b2b, Integer, from: "unitsOrderedB2B")
      end
    end
  end
end
