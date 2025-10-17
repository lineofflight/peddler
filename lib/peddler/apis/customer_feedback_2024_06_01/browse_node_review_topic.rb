# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review topic.
      BrowseNodeReviewTopic = Structure.new do
        # @return [BrowseNodeReviewTopicMetrics] The percentage of browse node reviews that mention the topic, and the
        #   effect the topic has on the star rating.
        attribute(:browse_node_metrics, BrowseNodeReviewTopicMetrics, from: "browseNodeMetrics")

        # @return [String] The name browse node review topic.
        attribute(:topic, String)

        # @return [Array<String>] A list of up to three snippets from reviews that contain the topic. This value is
        #   `null` if there aren't enough review snippets for the topic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")

        # @return [Array<BrowseNodeSubtopic>] A list of the five subtopics that occur most frequently. This value is
        #   `null` if there are no subtopics.
        attribute?(:subtopics, [BrowseNodeSubtopic])
      end
    end
  end
end
