# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The item review trend metrics.
      ReviewTrendMetrics = Structure.new do
        # @return [Float] The percentage of reviews that mention the topic.
        attribute(:occurrence_percentage, Float, from: "occurrencePercentage")
      end
    end
  end
end
