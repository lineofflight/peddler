# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      # An Amazon product type with a definition available.
      ProductType = Structure.new do
        # @return [String] The human-readable and localized description of the Amazon product type.
        attribute(:display_name, String, null: false, from: "displayName")

        # @return [Array<String>] The Amazon marketplace identifiers for which the product type definition is available.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # @return [String] The name of the Amazon product type.
        attribute(:name, String, null: false)
      end
    end
  end
end
