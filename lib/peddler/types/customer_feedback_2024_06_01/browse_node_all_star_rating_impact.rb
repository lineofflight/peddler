# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The effects of a topic on the star ratings in a browse node.
      BrowseNodeAllStarRatingImpact = Structure.new do
        # @return [Float] The effect of the topic on the star rating of all products in the browse node. This value can
        # be positive or negative.
        attribute(:all_products, Float, from: "allProducts")

        # @return [Float] The effect of the topic on the star rating of the top 25 percent of products in the browse
        # node. This value can be positive or negative.
        attribute(:top_twenty_five_percent_products, Float, from: "topTwentyFivePercentProducts")
      end
    end
  end
end
