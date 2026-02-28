# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module B2BProductOpportunitiesRecommendedForYouReport20201119
      # Provides B2B product recommendations based on predicted incremental units sold, unmet buyer demand, low offer
      # count, and other factors for products already offered on Amazon. The recommendations are personalized to the
      # Seller based on past sales activity.
      Report = Structure.new do
        # @return [Array<Object>] A list of B2B product opportunity recommendation objects.
        attribute(:recommendations, Array, null: false)
      end
    end
  end
end
