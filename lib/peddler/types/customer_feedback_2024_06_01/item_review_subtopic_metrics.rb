# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The item review subtopic metrics.
      ItemReviewSubtopicMetrics = Structure.new do
        # @return [Integer] The number of times that reviews mention the subtopic.
        attribute(:number_of_mentions, Integer, from: "numberOfMentions")

        # @return [Float] The percentage of reviews that mention the subtopic.
        attribute(:occurrence_percentage, Float, from: "occurrencePercentage")
      end
    end
  end
end
