# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The sales data for the seller's account aggregated by date.
      ByDateSales = Structure.new do
        # @return [Amount] The average ordered product sales, calculated by dividing orderedProductSales by
        #   totalOrderItems for the selected time period.
        attribute?(:average_sales_per_order_item, Amount, null: false, from: "averageSalesPerOrderItem")

        # @return [Amount] The average ordered product sales to Amazon Business customers, calculated by dividing
        #   orderedProductSalesB2B by totalOrderItemsB2B for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:average_sales_per_order_item_b2b, Amount, from: "averageSalesPerOrderItemB2B")

        # @return [Amount] The average price of the units sold for the selected time period, calculated by dividing the
        #   orderedProductSales by unitsOrdered for the selected time period.
        attribute?(:average_selling_price, Amount, null: false, from: "averageSellingPrice")

        # @return [Amount] The average price of the units sold to Amazon Business customers, calculated by dividing the
        #   orderedProductSalesB2B by unitsOrderedB2B for the selected time period. Note: This field is only populated
        #   when the seller is a B2B seller.
        attribute?(:average_selling_price_b2b, Amount, from: "averageSellingPriceB2B")

        # @return [Float] The average number of units in each order item for the selected time period.
        attribute?(:average_units_per_order_item, Float, null: false, from: "averageUnitsPerOrderItem")

        # @return [Float] The average number of units in each order item ordered by Amazon Business customers for the
        #   selected time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:average_units_per_order_item_b2b, Float, from: "averageUnitsPerOrderItemB2B")

        # @return [Amount] Monetary amount of filed A-to-z guarantee claims.
        attribute?(:claims_amount, Amount, null: false, from: "claimsAmount")

        # @return [Amount] Monetary amount of filed A-to-z guarantee claims for Amazon Business customers. Note: This
        #   field is only populated when the seller is a B2B seller.
        attribute?(:claims_amount_b2b, Amount, from: "claimsAmountB2B")

        # @return [String] The number of A-to-z guarantee claims granted.
        attribute?(:claims_granted, String, null: false, from: "claimsGranted")

        # @return [String] The number of A-to-z guarantee claims granted for Amazon Business customers.
        # Note: This field is only populated when the seller is a B2B seller.
        attribute?(:claims_granted_b2b, String, from: "claimsGrantedB2B")

        # @return [Amount] The amount of ordered product sales, calculated by multiplying the price of products and the
        #   number of units sold for the selected time period.
        attribute?(:ordered_product_sales, Amount, null: false, from: "orderedProductSales")

        # @return [Amount] The amount of ordered product sales to Amazon Business customers, calculated by multiplying
        #   the price of products and the number of units sold for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Amount, from: "orderedProductSalesB2B")

        # @return [String] The number of orders shipped for the selected time period.
        attribute?(:orders_shipped, String, null: false, from: "ordersShipped")

        # @return [String] The number of orders shipped to Amazon Business customers for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:orders_shipped_b2b, String, from: "ordersShippedB2B")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded by the seller,
        #   calculated by dividing unitsRefunded by unitsOrdered for the selected time period.
        attribute?(:refund_rate, Float, null: false, from: "refundRate")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded by Amazon Business
        #   customers, calculated by dividing unitsRefundedB2B by unitsOrderedB2B for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:refund_rate_b2b, Float, from: "refundRateB2B")

        # @return [Amount] The amount of ordered product sales shipped for the selected time period.
        attribute?(:shipped_product_sales, Amount, null: false, from: "shippedProductSales")

        # @return [Amount] The amount of ordered product sales shipped to Amazon Business customers for the selected
        #   time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:shipped_product_sales_b2b, Amount, from: "shippedProductSalesB2B")

        # @return [String] The number of items that were ordered for the selected time period. Example:
        # For an order containing 2 copies of book A and 3 copies of book B, the number of orders is 1, the number of
        #   order items is 2 (book A and book B), and the number of units is 5 (2 + 3).
        attribute?(:total_order_items, String, null: false, from: "totalOrderItems")

        # @return [String] The number of items that were ordered by Amazon Business customers for the selected time
        #   period. Example: For an order containing 2 copies of book A and 3 copies of book B, the number of orders is
        #   1, the number of order items is 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This
        #   field is only populated when the seller is a B2B seller.
        attribute?(:total_order_items_b2b, String, from: "totalOrderItemsB2B")

        # @return [String] The number of units ordered for the selected time period. Example: For an order containing 2
        #   copies of book A and 3 copies of book B, the number of orders is 1, the number of order items is 2 (book A
        #   and book B), and the number of units is 5 (2 + 3).
        attribute?(:units_ordered, String, null: false, from: "unitsOrdered")

        # @return [String] The number of units ordered by Amazon Business customers for the selected time period.
        #   Example: For an order containing 2 copies of book A and 3 copies of book B, the number of orders is 1, the
        #   number of order items is 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This field is
        #   only populated when the seller is a B2B seller.
        attribute?(:units_ordered_b2b, String, from: "unitsOrderedB2B")

        # @return [String] The number of units refunded for the selected time period.
        attribute?(:units_refunded, String, null: false, from: "unitsRefunded")

        # @return [String] The number of units refunded by Amazon Business customers for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:units_refunded_b2b, String, from: "unitsRefundedB2B")

        # @return [String] The number of units shipped for the selected time period.
        attribute?(:units_shipped, String, null: false, from: "unitsShipped")

        # @return [String] The number of units shipped to Amazon Business customers for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:units_shipped_b2b, String, from: "unitsShippedB2B")
      end
    end
  end
end
