# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The sales data for the seller's account aggregated by ASIN.
      ByASINSales = Structure.new do
        # @return [Amount] The amount of ordered product sales, calculated by multiplying the price of products and the
        #   number of units sold for the selected time period.
        attribute?(:ordered_product_sales, Amount, null: false, from: "orderedProductSales")

        # @return [Amount] The amount of ordered product sales to Amazon Business customers, calculated by multiplying
        #   the price of products and the number of units sold for the selected time period. Note: This field is only
        #   populated when the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Amount, from: "orderedProductSalesB2B")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded, calculated by
        #   dividing unitsRefunded by unitsOrdered for the selected time period.
        attribute?(:refund_rate, Float, null: false, from: "refundRate")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded by Amazon Business
        #   customers, calculated by dividing unitsRefundedB2B by unitsOrderedB2B for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:refund_rate_b2b, Float, from: "refundRateB2B")

        # @return [String] The number of items that were ordered for the selected time period.
        attribute?(:total_order_items, String, null: false, from: "totalOrderItems")

        # @return [String] The number of items that were ordered by Amazon Business customers for the selected time
        #   period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:total_order_items_b2b, String, from: "totalOrderItemsB2B")

        # @return [String] The number of units ordered.
        attribute?(:units_ordered, String, null: false, from: "unitsOrdered")

        # @return [String] The number of units ordered by Amazon Business customers. Note: This field is only populated
        #   when the seller is a B2B seller.
        attribute?(:units_ordered_b2b, String, from: "unitsOrderedB2B")

        # @return [String] The number of units refunded for the selected time period.
        attribute?(:units_refunded, String, null: false, from: "unitsRefunded")

        # @return [String] The number of units refunded by Amazon Business customers for the selected time period. Note:
        #   This field is only populated when the seller is a B2B seller.
        attribute?(:units_refunded_b2b, String, from: "unitsRefundedB2B")
      end
    end
  end
end
