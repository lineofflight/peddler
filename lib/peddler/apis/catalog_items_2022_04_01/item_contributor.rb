# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Individual contributor to the creation of an item, such as an author or actor.
      ItemContributor = Structure.new do
        attribute(:role, ItemContributorRole, null: false)

        # Name of the contributor, such as `Jane Austen`.
        attribute(:value, String, null: false)
      end
    end
  end
end
