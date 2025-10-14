# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      SellerFeedbackRating = Structure.new do
        # @return [Integer] The count of feedback received about the seller.
        attribute(:feedback_count, Integer, from: "feedbackCount")

        # @return [Float] The percentage of positive feedback for the seller in the past 365 days.
        attribute(:seller_positive_feedback_rating, Float, from: "sellerPositiveFeedbackRating")
      end
    end
  end
end
