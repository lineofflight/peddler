# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
      # Variation details for the Amazon catalog item for the indicated Amazon marketplace.
      ItemVariationsByMarketplace = Structure.new do
        # @return [Array<String>] Identifiers (ASINs) of the related items.
        attribute(:asins, [String], null: false)

        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] Type of variation relationship of the Amazon catalog item in the request to the related
        #   item(s): "PARENT" or "CHILD".
        attribute(:variation_type, String, null: false, from: "variationType")
      end
    end
  end
end
