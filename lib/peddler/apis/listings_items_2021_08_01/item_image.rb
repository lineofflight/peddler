# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The listings item's image.
      ItemImage = Structure.new do
        # @return [Integer] The image's height, in pixels.
        attribute(:height, Integer, null: false)

        # @return [String] The image's link or URL.
        attribute(:link, String, null: false)

        # @return [Integer] The image's width, in pixels.
        attribute(:width, Integer, null: false)
      end
    end
  end
end
