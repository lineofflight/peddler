# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A standard headline and body text.
      StandardTextModule = Structure.new do
        # @return [ParagraphComponent]
        attribute(:body, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
