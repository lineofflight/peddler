# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_return_trend_point"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The trend of return topic metrics for all items in the requested browse node.
      BrowseNodeReturnTrend = Structure.new do
        # @return [String] The name of the topic.
        attribute(:topic, String)

        # @return [Array<BrowseNodeReturnTrendPoint>] The browse node return trend metrics.
        attribute(:trend_metrics, [BrowseNodeReturnTrendPoint], from: "trendMetrics")
      end
    end
  end
end
