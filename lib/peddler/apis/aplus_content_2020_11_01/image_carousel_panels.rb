# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single image carousel panel.
      ImageCarouselPanels = Structure.new do
        # @return [ImageCarouselPanel]
        attribute(:image_panel, ImageCarouselPanel, null: false, from: "imagePanel")
      end
    end
  end
end
