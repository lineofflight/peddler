# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Customer review topics metric group. A null value for a given metric means that the metric is not available.
      CustomerReviewTopics = Structure.new do
        # @return [String] The ten most common negative topics extracted from customer reviews, based on how each topic
        # impacts the star rating.
        # ASIN metrics include each topic's impact value for both the ASIN and the corresponding Parent ASIN.
        # Browse node metrics include each topic's impact value for both the overall
        # browse node and the top 25% of products within it.
        attribute?(:negative_review_topic_impact_on_star_rating, String, from: "negativeReviewTopicImpactOnStarRating")

        # @return [String] Month-over-month trends of the ten most common negative topics based on customer reviews.
        # ASIN metrics include the occurrence percentage at both the ASIN and Parent ASIN level for each of the past six
        # months.
        # Browse node metrics include the occurrence percentage at both the overall
        # browse node level and among the top 25% of products within the browse node,
        # for each of the past six months.
        attribute?(:negative_review_topic_trends, String, from: "negativeReviewTopicTrends")

        # @return [String] The ten most common negative topics based on customer reviews. For each topic,
        # the top three associated snippets are provided verbatim. Additionally, the top
        # five subtopics for each topic and the top three verbatim quotes are provided.
        # ASIN metrics include the number of mentions and occurrence percentage of each topic or subtopic.
        # Browse node metrics include the occurrence percentage of the topic or subtopic at the overall browse node
        # level.
        attribute?(:negative_review_topics, String, from: "negativeReviewTopics")

        # @return [String] The ten most common positive topics extracted from customer reviews, based on how each topic
        # impacts the star rating.
        # ASIN metrics show each topic's impact value for both the ASIN and the corresponding Parent ASIN.
        # Browse node metrics show each topic's impact value for both the overall browse node and the top 25% of
        # products within it.
        attribute?(:positive_review_topic_impact_on_star_rating, String, from: "positiveReviewTopicImpactOnStarRating")

        # @return [String] Month-over-month trends of the ten most common positive topics based on customer reviews.
        # ASIN metrics show the occurrence percentage at both the ASIN and Parent ASIN level for each of the past six
        # months.
        # Browse node metrics show the occurrence percentage at both the overall browse
        # node level and among the top 25% of products within the browse node, for each
        # of the past six months.
        attribute?(:positive_review_topic_trends, String, from: "positiveReviewTopicTrends")

        # @return [String] The ten most common positive topics based on customer reviews. For each topic,
        # the top three associated snippets are provided verbatim. Additionally, the top
        # five subtopics are included for each topic, along with the top three verbatim quotes.
        # ASIN metrics include the number of mentions and occurrence percentage of each topic or subtopic.
        # Browse node metrics include the occurrence percentage of the topic or subtopic at the overall browse node
        # level.
        attribute?(:positive_review_topics, String, from: "positiveReviewTopics")
      end
    end
  end
end
