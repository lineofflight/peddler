# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The item review subtopic metrics.
      ItemReviewSubtopicMetrics = Structure.new do
        # @return [Integer] The number of times that reviews mention the subtopic.
        attribute(:number_of_mentions, Integer, null: false, from: "numberOfMentions")

        # @return [Float] The percentage of reviews that mention the subtopic.
        attribute(:occurrence_percentage, Float, null: false, from: "occurrencePercentage")
      end
    end
  end
end
