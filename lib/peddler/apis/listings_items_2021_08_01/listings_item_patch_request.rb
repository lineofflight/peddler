# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The request body schema for the `patchListingsItem` operation.
      ListingsItemPatchRequest = Structure.new do
        # @return [Array<PatchOperation>] One or more JSON Patch operations to perform on the listings item.
        attribute(:patches, [PatchOperation])

        # @return [String] The Amazon product type of the listings item.
        attribute(:product_type, String, from: "productType")
      end
    end
  end
end
