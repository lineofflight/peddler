# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      # An Amazon product type with a definition available.
      ProductType = Structure.new do
        # @return [String] The name of the Amazon product type.
        attribute(:name, String)

        # @return [String] The human-readable and localized description of the Amazon product type.
        attribute(:display_name, String, from: "displayName")

        # @return [Array<String>] The Amazon marketplace identifiers for which the product type definition is available.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end
