# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single regimen carousel panel.
      RegimenCarouselPanels = Structure.new do
        # @return [RegimenCarouselPanel]
        attribute(:regimen_panel, RegimenCarouselPanel, null: false, from: "regimenPanel")
      end
    end
  end
end
