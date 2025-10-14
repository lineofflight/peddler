# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
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
