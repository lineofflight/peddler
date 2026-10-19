# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20210801
      # The request body schema for the `putListingsItem` operation.
      ListingsItemPutRequest = Structure.new do
        # JSON object containing structured listings item attribute data keyed by attribute name.
        attribute(:attributes, Hash, null: false)

        # The listings item's Amazon product type.
        attribute(:product_type, String, null: false, from: "productType")

        # The name of the requirements set for the provided data. Known values: `LISTING`, `LISTING_PRODUCT_ONLY`,
        # `LISTING_OFFER_ONLY`.
        attribute?(:requirements, String)
      end
    end
  end
end
