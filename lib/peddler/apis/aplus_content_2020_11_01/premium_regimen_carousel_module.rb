# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A carousel with a module headline, full-width image panels, and navigation tabs. Each panel has its own inset
      # headline, inset body text, and navigation text.
      PremiumRegimenCarouselModule = Structure.new do
        # @return [Array<RegimenCarouselPanels>] The collection of regimen panels, which must contain between 2 and 5
        #   panels.
        attribute(:carousel_cards, [RegimenCarouselPanels], null: false, from: "carouselCards")

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
