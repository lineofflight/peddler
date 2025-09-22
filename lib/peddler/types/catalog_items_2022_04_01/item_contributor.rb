# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_2022_04_01/item_contributor_role"

module Peddler
  module Types
    module CatalogItems20220401
      # Individual contributor to the creation of an item, such as an author or actor.
      ItemContributor = Structure.new do
        # @return [ItemContributorRole]
        attribute(:role, ItemContributorRole)

        # @return [String] Name of the contributor, such as `Jane Austen`.
        attribute(:value, String)
      end
    end
  end
end
