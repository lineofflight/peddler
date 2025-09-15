# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Description of a brand that can be used to get more fine-grained search results.
      BrandRefinement = Structure.new do
        # @return [Integer] The estimated number of results that would still be returned if refinement key applied.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [String] Brand name. For display and can be used as a search refinement.
        attribute(:brand_name, String, from: "brandName")
      end
    end
  end
end
