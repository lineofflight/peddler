# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The trend of review topic metrics for all items in the requested browse node.
      BrowseNodeReviewTrend = Structure.new do
        # @return [String] The name of the topic.
        attribute(:topic, String, null: false)

        # @return [Array<BrowseNodeReviewTrendPoint>] The browse node's review trend metrics for the past six months.
        attribute(:trend_metrics, [BrowseNodeReviewTrendPoint], null: false, from: "trendMetrics")
      end
    end
  end
end
