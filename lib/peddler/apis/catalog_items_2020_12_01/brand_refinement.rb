# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
      # Description of a brand that can be used to get more fine-grained search results.
      BrandRefinement = Structure.new do
        # @return [String] Brand name. For display and can be used as a search refinement.
        attribute(:brand_name, String, from: "brandName")

        # @return [Integer] The estimated number of results that would still be returned if refinement key applied.
        attribute(:number_of_results, Integer, from: "numberOfResults")
      end
    end
  end
end
