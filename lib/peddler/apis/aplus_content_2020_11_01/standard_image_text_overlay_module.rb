# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A standard background image with a floating text box.
      StandardImageTextOverlayModule = Structure.new do
        # @return [String]
        attribute(:overlay_color_type, String, null: false, from: "overlayColorType")

        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)
      end
    end
  end
end
