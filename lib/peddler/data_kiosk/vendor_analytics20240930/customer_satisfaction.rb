# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Customer satisfaction metric group. A null value for a given metric means that the metric is not available.
      CustomerSatisfaction = Structure.new do
        # @return [CustomerReturnTopics] Customer return topics metric group.
        attribute?(:customer_return_topics, CustomerReturnTopics, from: "customerReturnTopics")

        # @return [String] The number of items returned as recorded on the Customer Returns transaction table.
        attribute?(:customer_returns, String, from: "customerReturns")

        # @return [CustomerReviews] Customer reviews metric group.
        attribute?(:customer_reviews, CustomerReviews, from: "customerReviews")
      end
    end
  end
end
