# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_trend_metrics"
require "peddler/types/customer_feedback_2024_06_01/date_range"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The return metrics for a certain month.
      BrowseNodeReturnTrendPoint = Structure.new do
        # @return [BrowseNodeTrendMetrics] The browse node return metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")

        # @return [DateRange] The range of dates during which the returns were made.
        attribute(:date_range, DateRange, from: "dateRange")
      end
    end
  end
end
