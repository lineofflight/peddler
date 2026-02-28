# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # A brand that you can use to refine your search.
      BrandRefinement = Structure.new do
        # @return [String] The brand name that you can use to refine your search.
        attribute(:brand_name, String, null: false, from: "brandName")

        # @return [Integer] The estimated number of results that would be returned if you refine your search by the
        #   specified `brandName`.
        attribute(:number_of_results, Integer, null: false, from: "numberOfResults")
      end
    end
  end
end
