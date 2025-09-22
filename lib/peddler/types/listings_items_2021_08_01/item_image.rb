# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # The image for the listings item.
      ItemImage = Structure.new do
        # @return [String] The link, or URL, to the image.
        attribute(:link, String)

        # @return [Integer] The height of the image in pixels.
        attribute(:height, Integer)

        # @return [Integer] The width of the image in pixels.
        attribute(:width, Integer)
      end
    end
  end
end
