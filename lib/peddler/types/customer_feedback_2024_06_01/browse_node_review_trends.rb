# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_review_trend"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The 10 most positive and most negative review topics for all items in a browse node.
      BrowseNodeReviewTrends = Structure.new do
        # @return [Array<BrowseNodeReviewTrend>] The trends of the most negative review topics. The percentage of
        # reviews that contain the topic across all products in the requested browse node determine the topic's
        # placement in the list. This value is `null` if there aren't enough positive reviews for the requested browse
        # node.
        #
        # **Max length:** 10
        attribute?(:negative_topics, [BrowseNodeReviewTrend], from: "negativeTopics")

        # @return [Array<BrowseNodeReviewTrend>] The trends of the most positive review topics. The percentage of
        # reviews that contain the topic across all products in the requested browse node determine the topic's
        # placement in the list. This value is `null` if there aren't enough positive reviews for the requested browse
        # node.
        #
        # **Max length:** 10
        attribute?(:positive_topics, [BrowseNodeReviewTrend], from: "positiveTopics")
      end
    end
  end
end
