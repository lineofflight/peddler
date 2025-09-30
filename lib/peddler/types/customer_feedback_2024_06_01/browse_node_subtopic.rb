# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/browse_node_review_subtopic_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The browse node review subtopic.
      BrowseNodeSubtopic = Structure.new do
        # @return [String] The name of the browse node review subtopic.
        attribute(:subtopic, String)

        # @return [BrowseNodeReviewSubtopicMetrics] The browse node review subtopic metrics.
        attribute(:metrics, BrowseNodeReviewSubtopicMetrics)

        # @return [Array<String>] A list of up to three snippets from reviews that contain the topic. This value is
        # `null` if there aren't enough review snippets for the subtopic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")
      end
    end
  end
end
