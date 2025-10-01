# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_all_occurrence"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The browse node review topic metrics.
      BrowseNodeReviewTrendMetrics = Structure.new do
        # @return [BrowseNodeAllOccurrence] The percent of reviews that mention the topic.
        attribute(:occurrence_percentage, BrowseNodeAllOccurrence, from: "occurrencePercentage")
      end
    end
  end
end
