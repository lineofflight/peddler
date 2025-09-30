# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/item_review_topic_metrics"
require "peddler/types/customer_feedback_2024_06_01/item_review_browse_node_metrics"
require "peddler/types/customer_feedback_2024_06_01/child_asin_metrics"
require "peddler/types/customer_feedback_2024_06_01/item_review_subtopic"

module Peddler
  module Types
    module CustomerFeedback20240601
      # Details of item review topic.
      ItemReviewTopic = Structure.new do
        # @return [String] The name of the item review topic.
        attribute(:topic, String)

        # @return [ItemReviewTopicMetrics] The ASIN's review topic metrics.
        attribute(:asin_metrics, ItemReviewTopicMetrics, from: "asinMetrics")

        # @return [ItemReviewTopicMetrics] The parent ASIN's review topic metrics. This value is `null` if there isn't
        # enough topic data for the parent ASIN.
        attribute?(:parent_asin_metrics, ItemReviewTopicMetrics, from: "parentAsinMetrics")

        # @return [ItemReviewBrowseNodeMetrics] The browse node's review topic metrics. This value is `null` if there
        # isn't enough topic data for the browse node.
        attribute?(:browse_node_metrics, ItemReviewBrowseNodeMetrics, from: "browseNodeMetrics")

        # @return [ChildAsinMetrics] The review topic metrics for other child ASINs that have the same parent ASIN. This
        # value is `null` if there isn't any child ASIN metric data.
        attribute?(:child_asin_metrics, ChildAsinMetrics, from: "childAsinMetrics")

        # @return [Array<String>] A list of up to three snippets from reviews that contain the topic. This value is
        # `null` if there aren't enough review snippets for the topic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")

        # @return [Array<ItemReviewSubtopic>] A list of up to five top subtopics for the topic. The percentage of
        # customer reviews that mention the subtopic determine the topic's placement in the list. This value is `null`
        # if there are no subtopics.
        attribute?(:subtopics, [ItemReviewSubtopic])
      end
    end
  end
end
