# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/brand_refinement"
require "peddler/types/catalog_items_2020_12_01/classification_refinement"

module Peddler
  module Types
    module CatalogItems20201201
      # Search refinements.
      Refinements = Structure.new do
        # @return [Array<BrandRefinement>] Brand search refinements.
        attribute(:brands, [BrandRefinement])

        # @return [Array<ClassificationRefinement>] Classification search refinements.
        attribute(:classifications, [ClassificationRefinement])
      end
    end
  end
end
