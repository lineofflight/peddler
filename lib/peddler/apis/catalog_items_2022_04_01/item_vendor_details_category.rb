# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # The product category or subcategory that is associated with an Amazon catalog item.
      ItemVendorDetailsCategory = Structure.new do
        # @return [String] The display name of the product category or subcategory.
        attribute?(:display_name, String, from: "displayName")

        # @return [String] The code that identifies the product category or subcategory.
        attribute?(:value, String)
      end
    end
  end
end
