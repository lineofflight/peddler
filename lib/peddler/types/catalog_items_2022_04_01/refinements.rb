# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_2022_04_01/brand_refinement"
require "peddler/types/catalog_items_2022_04_01/classification_refinement"

module Peddler
  module Types
    module CatalogItems20220401
      # Optional fields that you can use to refine your search results.
      Refinements = Structure.new do
        # @return [Array<BrandRefinement>] A list of brands you can use to refine your search.
        attribute(:brands, [BrandRefinement])

        # @return [Array<ClassificationRefinement>] A list of classifications you can use to refine your search.
        attribute(:classifications, [ClassificationRefinement])
      end
    end
  end
end
