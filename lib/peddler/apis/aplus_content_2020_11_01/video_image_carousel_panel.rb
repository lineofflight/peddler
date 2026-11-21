# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single panel within the video/image carousel containing a video or image with optional text.
      VideoImageCarouselPanel = Structure.new do
        # The position of the panel within the carousel. Must be a value between 1 and 6.
        attribute(:position, Integer, null: false)

        attribute?(:description, ParagraphComponent)

        attribute?(:desktop_image, ImageComponent, from: "desktopImage")

        attribute?(:mobile_image, ImageComponent, from: "mobileImage")

        # Known values: `LEFT`, `RIGHT`.
        attribute?(:position_type, String, from: "positionType")

        attribute?(:subheadline, TextComponent)

        attribute?(:title, TextComponent)

        attribute?(:video, VideoComponent)
      end
    end
  end
end
