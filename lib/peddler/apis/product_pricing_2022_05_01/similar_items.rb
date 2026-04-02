# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The summary of similar items for the specified ASIN `marketplaceId` combination.
      SimilarItems = Structure.new do
        # @return [Array<Item>] A list of similar items for the specified ASIN `marketplaceId` combination.
        attribute?(:items, [Item])
      end
    end
  end
end
