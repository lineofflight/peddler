# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Metrics broken down by metric groups, e.g., Product availability, Orders, Costs, Customer satisfaction.
      ManufacturingViewMetrics = Structure.new do
        # @return [Costs] Costs metric group.
        attribute?(:costs, Costs)

        # @return [CustomerSatisfaction] Customer satisfaction metric group.
        attribute?(:customer_satisfaction, CustomerSatisfaction, from: "customerSatisfaction")

        # @return [Array<ForecastedDemandWeekly>] Forecasting metric group.
        attribute?(:forecasting, [ForecastedDemandWeekly])

        # @return [Orders] Orders metric group.
        attribute?(:orders, Orders)

        # @return [ProductAvailability] Product availability metric group.
        attribute?(:product_availability, ProductAvailability, from: "productAvailability")

        # @return [ShippedOrders] Shipped orders metric group.
        attribute?(:shipped_orders, ShippedOrders, from: "shippedOrders")

        # @return [Sourcing] Sourcing metric group.
        attribute?(:sourcing, Sourcing)

        # @return [Traffic] Traffic metric group.
        attribute?(:traffic, Traffic)
      end
    end
  end
end
