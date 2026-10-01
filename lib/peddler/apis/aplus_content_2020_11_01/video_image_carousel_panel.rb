# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single panel within the video/image carousel containing a video or image with optional text.
      VideoImageCarouselPanel = Structure.new do
        # @return [Integer] The position of the panel within the carousel. Must be a value between 1 and 6.
        attribute(:position, Integer, null: false)

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [ImageComponent]
        attribute?(:desktop_image, ImageComponent, from: "desktopImage")

        # @return [ImageComponent]
        attribute?(:mobile_image, ImageComponent, from: "mobileImage")

        # @return [String]
        attribute?(:position_type, String, from: "positionType")

        # @return [TextComponent]
        attribute?(:subheadline, TextComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)

        # @return [VideoComponent]
        attribute?(:video, VideoComponent)
      end
    end
  end
end
