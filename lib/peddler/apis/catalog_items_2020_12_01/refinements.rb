# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
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
