# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The browse node review trend occurrence metrics.
      BrowseNodeOccurrence = Structure.new do
        # @return [Float] The percentage of reviews of products in the browse node that mention a topic.
        attribute(:all_products, Float, null: false, from: "allProducts")
      end
    end
  end
end
