# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Information about the seller's feedback, including the percentage of positive feedback, and the total number of
      # ratings received.
      SellerFeedbackType = Structure.new do
        # @return [Float] The percentage of positive feedback for the seller in the past 365 days.
        attribute(:seller_positive_feedback_rating, Float, from: "SellerPositiveFeedbackRating")

        # @return [Integer] The number of ratings received about the seller.
        attribute(:feedback_count, Integer, from: "FeedbackCount")
      end
    end
  end
end
