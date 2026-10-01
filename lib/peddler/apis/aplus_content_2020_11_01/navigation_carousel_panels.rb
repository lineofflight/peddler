# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single navigation carousel panel.
      NavigationCarouselPanels = Structure.new do
        # @return [NavigationCarouselPanel]
        attribute(:navigation_panel, NavigationCarouselPanel, null: false, from: "navigationPanel")
      end
    end
  end
end
