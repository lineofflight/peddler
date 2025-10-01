# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The browse node review subtopic metrics.
      BrowseNodeReviewSubtopicMetrics = Structure.new do
        # @return [Float] The percentage of reviews that mention the subtopic.
        attribute(:occurrence_percentage, Float, from: "occurrencePercentage")
      end
    end
  end
end
