# frozen_string_literal: true

require "peddler/types/customer_feedback_2024_06_01/browse_node_review_trend_point"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The trend of review topic metrics for all items in the requested browse node.
      BrowseNodeReviewTrend = Structure.new do
        # @return [String] The name of the topic.
        attribute(:topic, String)

        # @return [Array<BrowseNodeReviewTrendPoint>] The browse node's review trend metrics for the past six months.
        attribute(:trend_metrics, [BrowseNodeReviewTrendPoint], from: "trendMetrics")
      end
    end
  end
end
