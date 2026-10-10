# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20200901
      # The request body schema for the putListingsItem operation.
      ListingsItemPutRequest = Structure.new do
        # JSON object containing structured listings item attribute data keyed by attribute name.
        attribute(:attributes, Hash, null: false)

        # The Amazon product type of the listings item.
        attribute(:product_type, String, null: false, from: "productType")

        # The name of the requirements set for the provided data.
        attribute?(:requirements, String)
      end
    end
  end
end
