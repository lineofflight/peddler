# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/date_range"
require "peddler/types/customer_feedback_2024_06_01/review_trend_metrics"
require "peddler/types/customer_feedback_2024_06_01/browse_node_trend_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The review metrics for a certain month.
      ItemReviewTrendPoint = Structure.new do
        # @return [DateRange] The date range of the item review trend metric.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [ReviewTrendMetrics] The ASIN's review trend metrics.
        attribute(:asin_metrics, ReviewTrendMetrics, from: "asinMetrics")

        # @return [ReviewTrendMetrics] The parent ASIN's review trend metrics. This value is `null` if there isn't
        # enough topic data for the parent ASIN.
        attribute(:parent_asin_metrics, ReviewTrendMetrics, from: "parentAsinMetrics")

        # @return [BrowseNodeTrendMetrics] The browse node's review trend metrics. This value is `null` if there isn't
        # enough topic data for the browse node.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")
      end
    end
  end
end
