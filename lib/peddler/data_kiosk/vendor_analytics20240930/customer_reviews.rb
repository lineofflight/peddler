# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Customer review metric group. A null value for a given metric means that the metric is not available.
      CustomerReviews = Structure.new do
        # @return [CustomerReviewTopics] Topics based on customer reviews for an ASIN.
        attribute?(:asin_review_topics, CustomerReviewTopics, from: "asinReviewTopics")

        # @return [CustomerReviewTopics] Topics based on customer reviews, aggregated across all ASINs within the
        # browse node (product category) associated with this ASIN.
        attribute?(:browse_node_review_topics, CustomerReviewTopics, from: "browseNodeReviewTopics")
      end
    end
  end
end
