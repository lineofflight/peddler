# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # A brand that you can use to refine your search.
      BrandRefinement = Structure.new do
        # @return [Integer] The estimated number of results that would be returned if you refine your search by the
        # specified `brandName`.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [String] The brand name that you can use to refine your search.
        attribute(:brand_name, String, from: "brandName")
      end
    end
  end
end
