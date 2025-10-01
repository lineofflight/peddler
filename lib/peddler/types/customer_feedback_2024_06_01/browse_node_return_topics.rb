# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_trend_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # Topics from returns for all items in a browse node.
      BrowseNodeReturnTopics = Structure.new do
        # @return [BrowseNodeTrendMetrics] The browse node return topic metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")

        # @return [String] The name of the return feedback topic .
        attribute(:topic, String)
      end
    end
  end
end
