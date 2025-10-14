# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review topic metrics.
      BrowseNodeReviewTopicMetrics = Structure.new do
        # @return [BrowseNodeAllOccurrence] The percentage of reviews that mention a topic. This value is `null` if the
        # topic isn't mentioned enough in the reviews.
        attribute?(:occurrence_percentage, BrowseNodeAllOccurrence, from: "occurrencePercentage")

        # @return [BrowseNodeAllStarRatingImpact] The effect a topic has on the browse node's star rating. This value is
        # `null` if the topic doesn't affect the star rating of the browse node.
        attribute?(:star_rating_impact, BrowseNodeAllStarRatingImpact, from: "starRatingImpact")
      end
    end
  end
end
