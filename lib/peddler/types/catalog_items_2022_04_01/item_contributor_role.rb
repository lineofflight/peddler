# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # Role of an individual contributor in the creation of an item, such as author or actor.
      ItemContributorRole = Structure.new do
        # @return [String] Display name of the role in the requested locale, such as `Author` or `Actor`.
        attribute(:display_name, String, from: "displayName")

        # @return [String] Role value for the Amazon catalog item, such as `author` or `actor`.
        attribute(:value, String)
      end
    end
  end
end
