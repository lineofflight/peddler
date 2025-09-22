# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # A classification that you can use to refine your search.
      ClassificationRefinement = Structure.new do
        # @return [Integer] The estimated number of results that would be returned if you refine your search by the
        # specified `classificationId`.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [String] Display name for the classification.
        attribute(:display_name, String, from: "displayName")

        # @return [String] The identifier of the classification that you can use to refine your search.
        attribute(:classification_id, String, from: "classificationId")
      end
    end
  end
end
