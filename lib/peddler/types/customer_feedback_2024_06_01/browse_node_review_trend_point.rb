# frozen_string_literal: true

require "peddler/types/customer_feedback_2024_06_01/date_range"
require "peddler/types/customer_feedback_2024_06_01/browse_node_review_trend_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The browse node's review metrics for a certain month.
      BrowseNodeReviewTrendPoint = Structure.new do
        # @return [DateRange] The date range of the browse node review trend metric.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [BrowseNodeReviewTrendMetrics] The browse node review trend metrics.
        attribute(:browse_node_metrics, BrowseNodeReviewTrendMetrics, from: "browseNodeMetrics")
      end
    end
  end
end
