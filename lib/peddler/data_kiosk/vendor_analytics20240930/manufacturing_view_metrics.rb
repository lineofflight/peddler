# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Metrics broken down by metric groups, e.g., Product availability, Orders, Costs, Customer satisfaction.
      ManufacturingViewMetrics = Structure.new do
        # Costs metric group.
        attribute?(:costs, Costs)

        # Customer satisfaction metric group.
        attribute?(:customer_satisfaction, CustomerSatisfaction, from: "customerSatisfaction")

        # Forecasting metric group.
        attribute?(:forecasting, [ForecastedDemandWeekly])

        # Orders metric group.
        attribute?(:orders, Orders)

        # Product availability metric group.
        attribute?(:product_availability, ProductAvailability, from: "productAvailability")

        # Shipped orders metric group.
        attribute?(:shipped_orders, ShippedOrders, from: "shippedOrders")

        # Sourcing metric group.
        attribute?(:sourcing, Sourcing)

        # Traffic metric group.
        attribute?(:traffic, Traffic)
      end
    end
  end
end
