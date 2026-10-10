# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Image for an item in the Amazon catalog.
      ItemImage = Structure.new do
        # Height of the image in pixels.
        attribute(:height, Integer, null: false)

        # Link, or URL, for the image.
        attribute(:link, String, null: false)

        # Variant of the image, such as MAIN or PT01.
        attribute(:variant, String, null: false)

        # Width of the image in pixels.
        attribute(:width, Integer, null: false)
      end
    end
  end
end
