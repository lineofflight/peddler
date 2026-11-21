# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module MarketplaceASINPageViewMetrics
      # Contains aggregate ASIN page view metrics.
      MarketplaceASINPageViewMetrics = Structure.new do
        # ASIN for which the page view metrics are provided.
        attribute(:asin, String, null: false)

        # End time of the aggregation window in UTC.
        attribute(:end_time, Time, null: false, from: "endTime")

        # Marketplace for which the page view metrics are provided.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Total page views (count).
        attribute(:page_views, Integer, null: false, from: "pageViews")

        # Start time of the aggregation window in UTC.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
