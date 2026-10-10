# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CustomerFeedback20240601
      # The trend of return topic metrics for all items in the requested browse node.
      BrowseNodeReturnTrend = Structure.new do
        # The name of the topic.
        attribute(:topic, String, null: false)

        # The browse node return trend metrics.
        attribute(:trend_metrics, [BrowseNodeReturnTrendPoint], null: false, from: "trendMetrics")
      end
    end
  end
end
