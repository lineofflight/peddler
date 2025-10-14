# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # A classification that you can use to refine your search.
      ClassificationRefinement = Structure.new do
        # @return [String] The identifier of the classification that you can use to refine your search.
        attribute(:classification_id, String, from: "classificationId")

        # @return [String] Display name for the classification.
        attribute(:display_name, String, from: "displayName")

        # @return [Integer] The estimated number of results that would be returned if you refine your search by the
        # specified `classificationId`.
        attribute(:number_of_results, Integer, from: "numberOfResults")
      end
    end
  end
end
