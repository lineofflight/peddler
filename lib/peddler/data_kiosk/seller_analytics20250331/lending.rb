# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Lending metric group. A null value for a given metric means that this metric is not yet available.
      Lending = Structure.new do
        # @return [AmountWithBenchmarking] Total monetary amount disbursed to the seller from Amazon for sales and other
        #   transactions.
        attribute?(:disbursements, AmountWithBenchmarking)

        # @return [IntWithBenchmarking] Total number of orders that received customer feedback within a specified time
        #   period.
        attribute?(:feedback_order_count, IntWithBenchmarking, from: "feedbackOrderCount")

        # @return [String] Product category where seller achieved highest percentage of sales over past 12 months.
        attribute?(:primary_product_category, String, from: "primaryProductCategory")

        # @return [AmountWithBenchmarking] Total Gross Merchandise Sales generated in seller's main product category as
        #   of current day.
        attribute?(:primary_product_category_net_gms, AmountWithBenchmarking, from: "primaryProductCategoryNetGMS")

        # @return [IntWithBenchmarking] Total number of orders that resulted in refunds within a specified time period.
        attribute?(:refunds_order_count, IntWithBenchmarking, from: "refundsOrderCount")

        # @return [AmountWithBenchmarking] Total balance amount generated from standard order transactions.
        attribute?(:total_balance_by_standard_orders, AmountWithBenchmarking, from: "totalBalanceByStandardOrders")

        # @return [AmountWithBenchmarking] Total worth of seller's inventory stored in FBA warehouses based on 15-day
        #   average selling price.
        attribute?(:total_fba_inventory_value, AmountWithBenchmarking, from: "totalFbaInventoryValue")
      end
    end
  end
end
