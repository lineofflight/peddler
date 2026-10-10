# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Delivery speed-related count metrics for search performance.
      # Captures customer interactions (impressions, clicks, cart adds, purchases) filtered by shipping speed
      # availability.
      CountMetrics = Structure.new do
        # Number of cart additions where the specified delivery speed option was available.
        attribute?(:shipping_cart_add, IntWithBenchmarking, from: "shippingCartAdd")

        # Number of clicks where the specified delivery speed option was available.
        attribute?(:shipping_click, IntWithBenchmarking, from: "shippingClick")

        # Number of impressions where the specified delivery speed option was available.
        attribute?(:shipping_impression, IntWithBenchmarking, from: "shippingImpression")

        # Number of purchases where the specified delivery speed option was available.
        attribute?(:shipping_purchase, IntWithBenchmarking, from: "shippingPurchase")
      end
    end
  end
end
