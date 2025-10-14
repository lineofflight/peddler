# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
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
