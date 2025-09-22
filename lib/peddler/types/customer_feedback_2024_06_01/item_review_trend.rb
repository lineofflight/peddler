# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/item_review_trend_point"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The trend of review topic metrics for the requested item.
      ItemReviewTrend = Structure.new do
        # @return [String] The name of the item review topic.
        attribute(:topic, String)

        # @return [Array<ItemReviewTrendPoint>] The item's review trend metrics for the past six months.
        attribute(:trend_metrics, [ItemReviewTrendPoint], from: "trendMetrics")
      end
    end
  end
end
