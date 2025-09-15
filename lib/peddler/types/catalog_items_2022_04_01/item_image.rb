# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # Image for an item in the Amazon catalog.
      ItemImage = Structure.new do
        # @return [String] Variant of the image, such as `MAIN` or `PT01`.
        attribute(:variant, String)

        # @return [String] URL for the image.
        attribute(:link, String)

        # @return [Integer] Height of the image in pixels.
        attribute(:height, Integer)

        # @return [Integer] Width of the image in pixels.
        attribute(:width, Integer)
      end
    end
  end
end
