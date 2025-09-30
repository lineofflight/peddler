# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/item_review_subtopic_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # Details of the subtopic for an item review topic.
      ItemReviewSubtopic = Structure.new do
        # @return [String] The name of the subtopic.
        attribute(:subtopic, String)

        # @return [ItemReviewSubtopicMetrics] The subtopic metrics.
        attribute(:metrics, ItemReviewSubtopicMetrics)

        # @return [Array<String>] A list of up to three snippets from reviews that contain the subtopic. This value is
        # `null` if there aren't enough review snippets for the subtopic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")
      end
    end
  end
end
