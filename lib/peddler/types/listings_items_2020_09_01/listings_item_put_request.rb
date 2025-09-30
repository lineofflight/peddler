# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ListingsItems20200901
      # The request body schema for the putListingsItem operation.
      ListingsItemPutRequest = Structure.new do
        # @return [String] The Amazon product type of the listings item.
        attribute(:product_type, String, from: "productType")

        # @return [String] The name of the requirements set for the provided data.
        attribute?(:requirements, String)

        # @return [Hash] JSON object containing structured listings item attribute data keyed by attribute name.
        attribute(:attributes, Hash)
      end
    end
  end
end
