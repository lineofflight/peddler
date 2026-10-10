# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20210801
      # The listings item's image.
      ItemImage = Structure.new do
        # The image's height, in pixels.
        attribute(:height, Integer, null: false)

        # The image's link or URL.
        attribute(:link, String, null: false)

        # The image's width, in pixels.
        attribute(:width, Integer, null: false)
      end
    end
  end
end
