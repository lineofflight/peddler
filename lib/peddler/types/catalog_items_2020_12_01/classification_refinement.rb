# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Description of a classification that can be used to get more fine-grained search results.
      ClassificationRefinement = Structure.new do
        # @return [String] Identifier for the classification that can be used for search refinement purposes.
        attribute(:classification_id, String, from: "classificationId")

        # @return [String] Display name for the classification.
        attribute(:display_name, String, from: "displayName")

        # @return [Integer] The estimated number of results that would still be returned if refinement key applied.
        attribute(:number_of_results, Integer, from: "numberOfResults")
      end
    end
  end
end
