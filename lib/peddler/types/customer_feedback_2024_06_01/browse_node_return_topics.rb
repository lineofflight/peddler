# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/browse_node_trend_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # Topics from returns for all items in a browse node.
      BrowseNodeReturnTopics = Structure.new do
        # @return [String] The name of the return feedback topic .
        attribute(:topic, String)

        # @return [BrowseNodeTrendMetrics] The browse node return topic metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")
      end
    end
  end
end
