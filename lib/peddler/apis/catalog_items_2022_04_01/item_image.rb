# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Image for an item in the Amazon catalog.
      ItemImage = Structure.new do
        # @return [Integer] Height of the image in pixels.
        attribute(:height, Integer, null: false)

        # @return [String] URL for the image.
        attribute(:link, String, null: false)

        # @return [String] Variant of the image, such as `MAIN` or `PT01`.
        attribute(:variant, String, null: false)

        # @return [Integer] Width of the image in pixels.
        attribute(:width, Integer, null: false)
      end
    end
  end
end
