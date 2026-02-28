# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review subtopic.
      BrowseNodeSubtopic = Structure.new do
        # @return [BrowseNodeReviewSubtopicMetrics] The browse node review subtopic metrics.
        attribute(:metrics, BrowseNodeReviewSubtopicMetrics, null: false)

        # @return [String] The name of the browse node review subtopic.
        attribute(:subtopic, String, null: false)

        # @return [Array<String>] A list of up to three snippets from reviews that contain the topic. This value is
        #   `null` if there aren't enough review snippets for the subtopic.
        attribute?(:review_snippets, [String], from: "reviewSnippets")
      end
    end
  end
end
