# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ standard fixed-length list of text, with a related headline.
      StandardHeaderTextListBlock = Structure.new do
        attribute?(:block, StandardTextListBlock)

        attribute?(:headline, TextComponent)
      end
    end
  end
end
