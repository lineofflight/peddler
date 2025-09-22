# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/item_review_trend"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The 10 most positive and most negative review topics for all items in a browse node.
      ItemReviewTrends = Structure.new do
        # @return [Array<ItemReviewTrend>] A list of the most positive review topics. The percentage of reviews that
        # contain the topic determines the topic's placement in the list. This value is `null` if there are not enough
        # positive reviews for the specified ASIN.
        #
        # **Max length:** 10
        attribute(:positive_topics, [ItemReviewTrend], from: "positiveTopics")

        # @return [Array<ItemReviewTrend>] A list of the most negative review topics. The percentage of reviews that
        # contain the topic determines the topic's placement in the list. This value is `null` if there are not enough
        # negative reviews for the specified ASIN.
        #
        # **Max length:** 10
        attribute(:negative_topics, [ItemReviewTrend], from: "negativeTopics")
      end
    end
  end
end
