# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A Brand Story card displaying up to four product ASINs with images, enabling cross-selling to other products in
      # your catalog.
      BrandStoryFourASINModule = Structure.new do
        # @return [Array<AsinImages>] Exactly 4 ASIN image entries.
        attribute(:asin_images, [ASINImages], null: false, from: "asinImages")

        # @return [TextComponent]
        attribute(:title, TextComponent, null: false)

        # @return [TextComponent]
        attribute?(:brand_store_id, TextComponent, from: "brandStoreId")
      end
    end
  end
end
