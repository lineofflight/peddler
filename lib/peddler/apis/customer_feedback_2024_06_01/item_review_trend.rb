# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
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
