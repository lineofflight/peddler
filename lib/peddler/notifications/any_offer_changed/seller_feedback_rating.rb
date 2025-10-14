# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      SellerFeedbackRating = Structure.new do
        # @return [Integer]
        attribute(:feedback_count, Integer, from: "FeedbackCount")

        # @return [Integer]
        attribute(:seller_positive_feedback_rating, Integer, from: "SellerPositiveFeedbackRating")
      end
    end
  end
end
