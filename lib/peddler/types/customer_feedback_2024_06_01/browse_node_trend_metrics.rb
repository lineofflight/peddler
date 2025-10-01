# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/browse_node_occurrence"

module Peddler
  module Types
    module CustomerFeedback20240601
      # A single browse node review or return trend metric.
      BrowseNodeTrendMetrics = Structure.new do
        # @return [BrowseNodeOccurrence] The percentage of feedback that mentions the topic.
        attribute(:occurrence_percentage, BrowseNodeOccurrence, from: "occurrencePercentage")
      end
    end
  end
end
