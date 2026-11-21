# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      SellerFeedbackRating = Structure.new do
        attribute(:feedback_count, Integer, null: false, from: "FeedbackCount")

        attribute(:seller_positive_feedback_rating, Integer, null: false, from: "SellerPositiveFeedbackRating")
      end
    end
  end
end
