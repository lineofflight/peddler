# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The 10 most positive and most negative review topics for all items in a browse node.
      ItemReviewTrends = Structure.new do
        # @return [Array<ItemReviewTrend>] A list of the most negative review topics. The percentage of reviews that
        # contain the topic determines the topic's placement in the list. This value is `null` if there are not enough
        # negative reviews for the specified ASIN.
        #
        # **Max length:** 10
        attribute?(:negative_topics, [ItemReviewTrend], from: "negativeTopics")

        # @return [Array<ItemReviewTrend>] A list of the most positive review topics. The percentage of reviews that
        # contain the topic determines the topic's placement in the list. This value is `null` if there are not enough
        # positive reviews for the specified ASIN.
        #
        # **Max length:** 10
        attribute?(:positive_topics, [ItemReviewTrend], from: "positiveTopics")
      end
    end
  end
end
