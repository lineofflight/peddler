# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
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
