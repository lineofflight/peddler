# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ Content standard image and text block, with a related caption. The caption may not display on all
      # devices.
      StandardImageTextCaptionBlock = Structure.new do
        attribute?(:block, StandardImageTextBlock)

        attribute?(:caption, TextComponent)
      end
    end
  end
end
