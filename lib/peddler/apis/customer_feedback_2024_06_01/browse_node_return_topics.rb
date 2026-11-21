# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CustomerFeedback20240601
      # Topics from returns for all items in a browse node.
      BrowseNodeReturnTopics = Structure.new do
        # The browse node return topic metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, null: false, from: "browseNodeMetrics")

        # The name of the return feedback topic .
        attribute(:topic, String, null: false)
      end
    end
  end
end
