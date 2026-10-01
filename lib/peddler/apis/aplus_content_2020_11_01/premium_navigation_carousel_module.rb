# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A carousel of full-width image panels with clickable navigation tabs. Each panel has its own navigation text,
      # subheadline, headline, and body text.
      PremiumNavigationCarouselModule = Structure.new do
        # @return [Array<NavigationCarouselPanels>] The collection of navigation panels, which must contain between 2
        #   and 5 panels.
        attribute(:carousel_cards, [NavigationCarouselPanels], null: false, from: "carouselCards")
      end
    end
  end
end
