# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Role of an individual contributor in the creation of an item, such as author or actor.
      ItemContributorRole = Structure.new do
        # @return [String] Role value for the Amazon catalog item, such as `author` or `actor`.
        attribute(:value, String, null: false)

        # @return [String] Display name of the role in the requested locale, such as `Author` or `Actor`.
        attribute?(:display_name, String, from: "displayName")
      end
    end
  end
end
