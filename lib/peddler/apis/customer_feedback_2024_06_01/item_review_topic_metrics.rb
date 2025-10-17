# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The item review topic metrics.
      ItemReviewTopicMetrics = Structure.new do
        # @return [Integer] The number of times that reviews mention the topic. This value is `null` if reviews do not
        #   mention the topic frequently enough.
        attribute?(:number_of_mentions, Integer, from: "numberOfMentions")

        # @return [Float] The percentage of customer reviews that mention the topic. This value is `null` if reviews do
        #   not mention the topic frequently enough.
        attribute?(:occurrence_percentage, Float, from: "occurrencePercentage")

        # @return [Float] The effect of the topic on the star rating of the ASIN. This value can be positive or
        #   negative. This value is `null` if the topic does't affect the star rating of the ASIN.
        attribute?(:star_rating_impact, Float, from: "starRatingImpact")
      end
    end
  end
end
