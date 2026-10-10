# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A full-width video with optional headline and body text below.
      PremiumHeroVideoModule = Structure.new do
        attribute(:hero_video, VideoComponent, null: false, from: "heroVideo")

        attribute?(:footer, ParagraphComponent)

        attribute?(:headline, TextComponent)
      end
    end
  end
end
