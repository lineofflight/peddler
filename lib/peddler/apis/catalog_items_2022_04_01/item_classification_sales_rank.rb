# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Sales rank of an Amazon catalog item.
      ItemClassificationSalesRank = Structure.new do
        # @return [String] Identifier of the classification that is associated with the sales rank.
        attribute(:classification_id, String, from: "classificationId")

        # @return [Integer] Sales rank.
        attribute(:rank, Integer)

        # @return [String] Name of the sales rank.
        attribute(:title, String)

        # @return [String] Corresponding Amazon retail website URL for the sales category.
        attribute?(:link, String)
      end
    end
  end
end
