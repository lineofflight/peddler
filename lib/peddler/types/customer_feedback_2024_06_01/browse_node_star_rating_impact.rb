# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The effects of a topic on a browse node's star rating.
      BrowseNodeStarRatingImpact = Structure.new do
        # @return [Float] The effect of the topic on the star rating for all products in this browse node. This value
        # can be positive or negative.
        attribute(:all_products, Float, from: "allProducts")
      end
    end
  end
end
