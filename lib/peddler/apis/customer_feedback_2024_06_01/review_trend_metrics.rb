# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The item review trend metrics.
      ReviewTrendMetrics = Structure.new do
        # @return [Float] The percentage of reviews that mention the topic.
        attribute(:occurrence_percentage, Float, from: "occurrencePercentage")
      end
    end
  end
end
