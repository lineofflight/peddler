# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # Details of the subtopic for an item review topic.
      ItemReviewSubtopic = Structure.new do
        # @return [ItemReviewSubtopicMetrics] The subtopic metrics.
        attribute(:metrics, ItemReviewSubtopicMetrics, null: false)

        # @return [String] The name of the subtopic.
        attribute(:subtopic, String, null: false)

        # @return [Array<String>] A list of up to three snippets from reviews that contain the subtopic. This value is
        #   `null` if there aren't enough review snippets for the subtopic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")
      end
    end
  end
end
