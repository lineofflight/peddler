# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CustomerFeedback20240601
      # The trend of review topic metrics for the requested item.
      ItemReviewTrend = Structure.new do
        # The name of the item review topic.
        attribute(:topic, String, null: false)

        # The item's review trend metrics for the past six months.
        attribute(:trend_metrics, [ItemReviewTrendPoint], null: false, from: "trendMetrics")
      end
    end
  end
end
