# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The image for the listings item.
      ItemImage = Structure.new do
        # @return [Integer] The height of the image in pixels.
        attribute(:height, Integer)

        # @return [String] The link, or URL, to the image.
        attribute(:link, String)

        # @return [Integer] The width of the image in pixels.
        attribute(:width, Integer)
      end
    end
  end
end
