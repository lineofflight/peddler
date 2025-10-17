# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review occurrence metrics.
      BrowseNodeAllOccurrence = Structure.new do
        # @return [Float] The percentage of reviews of products in the browse node that mention the topic.
        attribute(:all_products, Float, from: "allProducts")

        # @return [Float] The percentage of reviews of the top 25 percent of products in the browse node that mention
        #   the topic.
        attribute(:top_twenty_five_percent_products, Float, from: "topTwentyFivePercentProducts")
      end
    end
  end
end
