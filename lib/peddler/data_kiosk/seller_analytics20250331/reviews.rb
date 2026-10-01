# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Reviews metric group. A null value for a given metric means that this metric is not yet available.
      Reviews = Structure.new do
        # @return [FloatWithBenchmarking] Fraction (between 0 and 1) of customer reviews that are low-rating (critical),
        #   calculated as lowRatingReviewCount divided by totalReviewCount. Not supported under totals.
        attribute?(:critical_review_rate, FloatWithBenchmarking, from: "criticalReviewRate")

        # @return [FloatWithBenchmarking] Rounded star rating shown on the product detail page (1-5).
        # Reflects the overall rating state as of the requested date, not activity within the period.
        # Null when the product has no ratings yet. Not supported under totals.
        attribute?(:display_rating, FloatWithBenchmarking, from: "displayRating")

        # @return [IntWithBenchmarking] Number of low-rating customer reviews (critical reviews) received for the
        #   product in the selected time period.
        attribute?(:low_rating_review_count, IntWithBenchmarking, from: "lowRatingReviewCount")

        # @return [FloatWithBenchmarking] Unrounded average star rating for the product (1-5).
        # Reflects the overall rating state as of the requested date, not activity within the period.
        # Null when the product has no ratings yet. Not supported under totals.
        attribute?(:raw_rating, FloatWithBenchmarking, from: "rawRating")

        # @return [IntWithBenchmarking] Total number of verified buyer reviews contributing to the product's star
        #   rating, as of the requested date. Differs from totalReviewCount, which counts reviews received in the
        #   selected time period. Not supported under totals.
        attribute?(:total_rating_count, IntWithBenchmarking, from: "totalRatingCount")

        # @return [IntWithBenchmarking] Total number of customer reviews received for the product in the selected time
        #   period.
        attribute?(:total_review_count, IntWithBenchmarking, from: "totalReviewCount")
      end
    end
  end
end
