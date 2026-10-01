# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Root type for Seller Analytics queries version 2025_03_31.
      AnalyticsSelleranalytics20250331 = Structure.new do
        # @return [Array<SellerAnalyticsView>] A query to retrieve cross-domain seller analytics data for the seller's
        #   account, aggregated by provided GroupByAttributes.
        attribute?(:seller_analytics_view, [SellerAnalyticsView], from: "sellerAnalyticsView")
      end
    end
  end
end
