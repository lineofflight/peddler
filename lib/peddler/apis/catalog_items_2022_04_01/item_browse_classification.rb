# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Classification (browse node) for an Amazon catalog item.
      ItemBrowseClassification = Structure.new do
        # Identifier of the classification.
        attribute(:classification_id, String, null: false, from: "classificationId")

        # Display name for the classification.
        attribute(:display_name, String, null: false, from: "displayName")

        # Parent classification of the current classification.
        attribute?(:parent, :self)
      end
    end
  end
end
