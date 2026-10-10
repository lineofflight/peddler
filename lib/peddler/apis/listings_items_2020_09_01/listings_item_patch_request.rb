# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20200901
      # The request body schema for the patchListingsItem operation.
      ListingsItemPatchRequest = Structure.new do
        # One or more JSON Patch operations to perform on the listings item.
        attribute(:patches, [PatchOperation], null: false)

        # The Amazon product type of the listings item.
        attribute(:product_type, String, null: false, from: "productType")
      end
    end
  end
end
