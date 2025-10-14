# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `createMarketplaceItemLabels` request.
      CreateMarketplaceItemLabelsRequest = Structure.new do
        # @return [String]
        attribute(:label_type, String, from: "labelType")

        # @return [String] The Marketplace ID. For a list of possible values, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<MskuQuantity>] Represents the quantity of an MSKU to print item labels for.
        attribute(:msku_quantities, [MskuQuantity], from: "mskuQuantities")

        # @return [Float] The height of the item label.
        attribute?(:height, Float)

        # @return [String] The locale code constructed from ISO 639 language code and ISO 3166-1 alpha-2 standard of
        # country codes separated by an underscore character.
        attribute?(:locale_code, String, from: "localeCode")

        # @return [String]
        attribute?(:page_type, String, from: "pageType")

        # @return [Float] The width of the item label.
        attribute?(:width, Float)
      end
    end
  end
end
