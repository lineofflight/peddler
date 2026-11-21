# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Description of a brand that can be used to get more fine-grained search results.
      BrandRefinement = Structure.new do
        # Brand name. For display and can be used as a search refinement.
        attribute(:brand_name, String, null: false, from: "brandName")

        # The estimated number of results that would still be returned if refinement key applied.
        attribute(:number_of_results, Integer, null: false, from: "numberOfResults")
      end
    end
  end
end
