# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
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
