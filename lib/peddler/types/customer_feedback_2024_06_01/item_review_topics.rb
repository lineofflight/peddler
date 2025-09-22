# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/item_review_topic"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The top 10 positive and negative item review topics.
      ItemReviewTopics = Structure.new do
        # @return [Array<ItemReviewTopic>] A list of the most positive review topics. When the `sortBy` query parameter
        # is set to `MENTIONS`, the number of reviews that mention the topic determines the topic's placement in the
        # list. When `sortBy` is set to `STAR_RATING_IMPACT`, the effect that the topic has on the star rating of the
        # item determines placement in the list. This value is `null` if there are not enough positive reviews for the
        # specified ASIN.
        #
        # **Max length:** 10
        attribute(:positive_topics, [ItemReviewTopic], from: "positiveTopics")

        # @return [Array<ItemReviewTopic>] A list of the most negative review topics. When the `sortBy` query parameter
        # is set to `MENTIONS`, the number of reviews that mention the topic determines the topic's placement in the
        # list. When `sortBy` is set to `STAR_RATING_IMPACT`, the effect that the topic has on the star rating of the
        # item determines placement in the list. This value is `null` if there are not enough negative reviews for the
        # specified ASIN.
        #
        # **Max length:** 10
        attribute(:negative_topics, [ItemReviewTopic], from: "negativeTopics")
      end
    end
  end
end
