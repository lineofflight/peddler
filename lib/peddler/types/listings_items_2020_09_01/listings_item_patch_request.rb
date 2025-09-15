# frozen_string_literal: true

require "peddler/types/listings_items_2020_09_01/patch_operation"

module Peddler
  module Types
    module ListingsItems20200901
      # The request body schema for the patchListingsItem operation.
      ListingsItemPatchRequest = Structure.new do
        # @return [String] The Amazon product type of the listings item.
        attribute(:product_type, String, from: "productType")

        # @return [Array<PatchOperation>] One or more JSON Patch operations to perform on the listings item.
        attribute(:patches, [PatchOperation])
      end
    end
  end
end
