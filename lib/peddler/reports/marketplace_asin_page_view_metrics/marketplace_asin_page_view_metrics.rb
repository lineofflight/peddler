# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module MarketplaceASINPageViewMetrics
      # Contains aggregate ASIN page view metrics.
      MarketplaceASINPageViewMetrics = Structure.new do
        # @return [String] ASIN for which the page view metrics are provided.
        attribute(:asin, String, null: false)

        # @return [Time] End time of the aggregation window in UTC.
        attribute(:end_time, Time, null: false, from: "endTime")

        # @return [String] Marketplace for which the page view metrics are provided.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Integer] Total page views (count).
        attribute(:page_views, Integer, null: false, from: "pageViews")

        # @return [Time] Start time of the aggregation window in UTC.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
