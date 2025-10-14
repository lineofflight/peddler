# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The request body schema for the `putListingsItem` operation.
      ListingsItemPutRequest = Structure.new do
        # @return [Hash] A JSON object containing structured listings item attribute data keyed by attribute name.
        attribute(:attributes, Hash)

        # @return [String] The Amazon product type of the listings item.
        attribute(:product_type, String, from: "productType")

        # @return [String] The name of the requirements set for the provided data.
        attribute?(:requirements, String)
      end
    end
  end
end
