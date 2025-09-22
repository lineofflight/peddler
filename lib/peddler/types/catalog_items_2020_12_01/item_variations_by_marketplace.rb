# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Variation details for the Amazon catalog item for the indicated Amazon marketplace.
      ItemVariationsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<String>] Identifiers (ASINs) of the related items.
        attribute(:asins, [String])

        # @return [String] Type of variation relationship of the Amazon catalog item in the request to the related
        # item(s): "PARENT" or "CHILD".
        attribute(:variation_type, String, from: "variationType")
      end
    end
  end
end
