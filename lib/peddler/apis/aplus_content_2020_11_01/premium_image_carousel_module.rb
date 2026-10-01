# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A carousel of full-width image panels, each with its own headline and body text. Users swipe or click through
      # panels.
      PremiumImageCarouselModule = Structure.new do
        # @return [Array<ImageCarouselPanels>] The collection of image panels, which must contain between 2 and 6
        #   panels.
        attribute(:carousel_cards, [ImageCarouselPanels], null: false, from: "carouselCards")

        # @return [ParagraphComponent]
        attribute?(:footer, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
