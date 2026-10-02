# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for CustomerFeedback
    #
    # The Selling Partner API for Customer Feedback (Customer Feedback API) provides information about customer reviews
    # and returns at both the item and browse node level.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/customer-feedback-api-model/customerFeedback_2024-06-01.json
    module CustomerFeedback20240601
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "customer_feedback_2024_06_01.get_browse_node_return_topics" => -> { BrowseNodeReturnTopicsResponse },
        "customer_feedback_2024_06_01.get_browse_node_return_trends" => -> { BrowseNodeReturnTrendsResponse },
        "customer_feedback_2024_06_01.get_browse_node_review_topics" => -> { BrowseNodeReviewTopicsResponse },
        "customer_feedback_2024_06_01.get_browse_node_review_trends" => -> { BrowseNodeReviewTrendsResponse },
        "customer_feedback_2024_06_01.get_item_browse_node" => -> { BrowseNodeResponse },
        "customer_feedback_2024_06_01.get_item_review_topics" => -> { ItemReviewTopicsResponse },
        "customer_feedback_2024_06_01.get_item_review_trends" => -> { ItemReviewTrendsResponse },
      }.freeze
    end
  end
end
