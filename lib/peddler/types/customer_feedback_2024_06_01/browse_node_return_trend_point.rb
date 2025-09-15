# frozen_string_literal: true

require "peddler/types/customer_feedback_2024_06_01/date_range"
require "peddler/types/customer_feedback_2024_06_01/browse_node_trend_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The return metrics for a certain month.
      BrowseNodeReturnTrendPoint = Structure.new do
        # @return [DateRange] The range of dates during which the returns were made.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [BrowseNodeTrendMetrics] The browse node return metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")
      end
    end
  end
end
