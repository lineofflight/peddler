# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Metrics broken down by metric groups, e.g., Product availability, Costs, Customer satisfaction.
      SourcingViewMetrics = Structure.new do
        # Costs metric group.
        attribute?(:costs, Costs)

        # Customer satisfaction metric group.
        attribute?(:customer_satisfaction, CustomerSatisfaction, from: "customerSatisfaction")

        # Product availability metric group.
        attribute?(:product_availability, ProductAvailability, from: "productAvailability")

        # Shipped orders metric group.
        attribute?(:shipped_orders, ShippedOrders, from: "shippedOrders")

        # Sourcing metric group.
        attribute?(:sourcing, Sourcing)
      end
    end
  end
end
