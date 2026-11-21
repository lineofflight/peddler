# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Search refinements.
      Refinements = Structure.new do
        # Brand search refinements.
        attribute(:brands, [BrandRefinement], null: false)

        # Classification search refinements.
        attribute(:classifications, [ClassificationRefinement], null: false)
      end
    end
  end
end
