# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A carousel of panels, each containing a video or image with its own panel headline, subheadline, and body text.
      # A module headline appears above the carousel.
      PremiumVideoImageCarouselModule = Structure.new do
        # The list of carousel panels, between 2 and 6 items.
        attribute(:carousel_cards, [VideoImageCarouselPanels], null: false, from: "carouselCards")

        attribute?(:headline, TextComponent)
      end
    end
  end
end
