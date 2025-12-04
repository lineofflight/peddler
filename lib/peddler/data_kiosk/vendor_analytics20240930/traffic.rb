# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Traffic metric group. A null value for a given metric means that the metric is not available.
      Traffic = Structure.new do
        # @return [String] Glance views where Retail is the featured offer (i.e., winning the buy box).
        attribute?(:glance_views, String, from: "glanceViews")

        # @return [Float] The percentage of product page views where your offer loses the Featured Offer position (Buy
        #   Box) to others. It is equal to the number of glance views where you do not win the Featured Offer divided by
        #   the total number of glance views.
        attribute?(:lost_featured_offer, Float, from: "lostFeaturedOffer")
      end
    end
  end
end
