# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Classification (browse node) for an Amazon catalog item.
      ItemBrowseClassification = Structure.new do
        # @return [String] Identifier of the classification.
        attribute(:classification_id, String, from: "classificationId")

        # @return [String] Display name for the classification.
        attribute(:display_name, String, from: "displayName")

        # @return [:self] Parent classification of the current classification.
        attribute?(:parent, :self)
      end
    end
  end
end
