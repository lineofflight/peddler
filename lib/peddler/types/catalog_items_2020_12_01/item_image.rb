# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Image for an item in the Amazon catalog.
      ItemImage = Structure.new do
        # @return [Integer] Height of the image in pixels.
        attribute(:height, Integer)

        # @return [String] Link, or URL, for the image.
        attribute(:link, String)

        # @return [String] Variant of the image, such as MAIN or PT01.
        attribute(:variant, String)

        # @return [Integer] Width of the image in pixels.
        attribute(:width, Integer)
      end
    end
  end
end
