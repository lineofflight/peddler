# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Sales rank of an Amazon catalog item.
      ItemClassificationSalesRank = Structure.new do
        # Identifier of the classification that is associated with the sales rank.
        attribute(:classification_id, String, null: false, from: "classificationId")

        # Sales rank.
        attribute(:rank, Integer, null: false)

        # Name of the sales rank.
        attribute(:title, String, null: false)

        # Corresponding Amazon retail website URL for the sales category.
        attribute?(:link, String)
      end
    end
  end
end
