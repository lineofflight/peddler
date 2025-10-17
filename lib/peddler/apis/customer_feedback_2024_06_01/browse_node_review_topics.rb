# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The 10 most positive and most negative review topics for all items in a browse node.
      BrowseNodeReviewTopics = Structure.new do
        # @return [Array<BrowseNodeReviewTopic>] A list of the most negative review topics. When the `sortBy` query
        #   parameter is set to `MENTIONS`, the number of reviews of items within the requested browse node that mention
        #   the topic determine the topic's placement in the list. When `sortBy` is set to `STAR_RATING_IMPACT`, the
        #   effect that the topic has on the star rating of items within the requested browse node determine placement
        #   in the list. This value is `null` if there are not enough negative reviews for the requested browse node.
        #
        # **Max length:** 10
        attribute?(:negative_topics, [BrowseNodeReviewTopic], from: "negativeTopics")

        # @return [Array<BrowseNodeReviewTopic>] A list of the most positive review topics. When the `sortBy` query
        #   parameter is set to `MENTIONS`, the number of reviews of items within the requested browse node that mention
        #   the topic determine the topic's placement in the list. When `sortBy` is set to `STAR_RATING_IMPACT`, the
        #   effect that the topic has on the star rating of items within the requested browse node determine placement
        #   in the list. This value is `null` if there are not enough positive reviews for the requested browse node.
        #
        # **Max length:** 10
        attribute?(:positive_topics, [BrowseNodeReviewTopic], from: "positiveTopics")
      end
    end
  end
end
