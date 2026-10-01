# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single video/image carousel panel.
      VideoImageCarouselPanels = Structure.new do
        # @return [VideoImageCarouselPanel]
        attribute(:video_carousel_panel, VideoImageCarouselPanel, null: false, from: "videoCarouselPanel")
      end
    end
  end
end
