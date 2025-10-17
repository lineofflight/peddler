# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review topic metrics.
      ItemReviewBrowseNodeMetrics = Structure.new do
        # @return [BrowseNodeOccurrence] The percentage of reviews that mention the topic. This value is `null` if
        #   reviews do not mention the topic frequently enough.
        attribute?(:occurrence_percentage, BrowseNodeOccurrence, from: "occurrencePercentage")

        # @return [BrowseNodeStarRatingImpact] The effect of the topic on the star rating of items in the browse node.
        #   This value is `null` if the topic does not affect the star rating of the browse node.
        attribute?(:star_rating_impact, BrowseNodeStarRatingImpact, from: "starRatingImpact")
      end
    end
  end
end
