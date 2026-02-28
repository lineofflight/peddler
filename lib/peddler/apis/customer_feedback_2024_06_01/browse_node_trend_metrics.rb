# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # A single browse node review or return trend metric.
      BrowseNodeTrendMetrics = Structure.new do
        # @return [BrowseNodeOccurrence] The percentage of feedback that mentions the topic.
        attribute(:occurrence_percentage, BrowseNodeOccurrence, null: false, from: "occurrencePercentage")
      end
    end
  end
end
