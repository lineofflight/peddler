# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing sales metrics for ASINs in the seller's account aggregated by date.
      SalesByDate = Structure.new do
        # @return [Money] The average ordered product sales, calculated by dividing orderedProductSales by
        #   totalOrderItems for the selected time period.
        attribute(:average_sales_per_order_item, Money, from: "averageSalesPerOrderItem")

        # @return [Money] The average price of the units sold in the selected time period, calculated by dividing the
        #   orderedProductSales by unitsOrdered for the selected time period.
        attribute(:average_selling_price, Money, from: "averageSellingPrice")

        # @return [Float] The average number of units in each order item for the selected time period.
        attribute(:average_units_per_order_item, Float, from: "averageUnitsPerOrderItem")

        # @return [Money] Monetary amount of filed A-to-z guarantee claims.
        attribute(:claims_amount, Money, from: "claimsAmount")

        # @return [Integer] The number of A-to-z guarantee claims granted.
        attribute(:claims_granted, Integer, from: "claimsGranted")

        # @return [Money] The amount of ordered product sales, calculated by multiplying the price of products and the
        #   number of units sold for the selected time period.
        attribute(:ordered_product_sales, Money, from: "orderedProductSales")

        # @return [Integer] The number of orders shipped in the selected time period.
        attribute(:orders_shipped, Integer, from: "ordersShipped")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded by the seller,
        #   calculated by dividing unitsOrdered by unitsRefunded in the selected time period.
        attribute(:refund_rate, Float, from: "refundRate")

        # @return [Money] The amount of ordered product sales shipped for the selected time period.
        attribute(:shipped_product_sales, Money, from: "shippedProductSales")

        # @return [Integer] The number of items that were ordered for the selected time period. For clarification on the
        #   difference between orders, order items, and units take the following order as an example: An order
        #   containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the number of order items
        #   is 2 (book A and book B), and the number of units is 5 (2 + 3).
        attribute(:total_order_items, Integer, from: "totalOrderItems")

        # @return [Integer] The number of units ordered for the selected time period. For clarification on the
        #   difference between orders, order items, and units take the following order as an example: An order
        #   containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the number of order items
        #   is 2 (book A and book B), and the number of units is 5 (2 + 3).
        attribute(:units_ordered, Integer, from: "unitsOrdered")

        # @return [Integer] The number of units refunded in the selected time period.
        attribute(:units_refunded, Integer, from: "unitsRefunded")

        # @return [Integer] The number of units shipped in the selected time period.
        attribute(:units_shipped, Integer, from: "unitsShipped")

        # @return [Money] The average ordered product sales to Amazon Business customers, calculated by dividing
        #   orderedProductSalesB2B by totalOrderItemsB2B for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:average_sales_per_order_item_b2b, Money, from: "averageSalesPerOrderItemB2B")

        # @return [Money] The average price of the units sold to Amazon Business customers, calculated by dividing the
        #   orderedProductSalesB2B by unitsOrderedB2B for the selected time period. Note: This field is only populated
        #   when the seller is a B2B seller.
        attribute?(:average_selling_price_b2b, Money, from: "averageSellingPriceB2B")

        # @return [Float] The average number of units in each order item ordered by Amazon Business customers for the
        #   selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:average_units_per_order_item_b2b, Float, from: "averageUnitsPerOrderItemB2B")

        # @return [Money] The amount of ordered product sales to Amazon Business customers, calculated by multiplying
        #   the price of products and the number of units sold for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Money, from: "orderedProductSalesB2B")

        # @return [Integer] The number of items that were ordered by Amazon Business customers for the selected time
        #   period. For clarification on the difference between orders, order items, and units take the following order
        #   as an example: An order containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the
        #   number of order items is 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This field is
        #   only populated when the seller is a B2B seller.
        attribute?(:total_order_items_b2b, Integer, from: "totalOrderItemsB2B")

        # @return [Integer] The number of units ordered by Amazon Business customers for the selected time period. For
        #   clarification on the difference between orders, order items, and units take the following order as an
        #   example: An order containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the
        #   number of order items is 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This field is
        #   only populated when the seller is a B2B seller.
        attribute?(:units_ordered_b2b, Integer, from: "unitsOrderedB2B")
      end
    end
  end
end
