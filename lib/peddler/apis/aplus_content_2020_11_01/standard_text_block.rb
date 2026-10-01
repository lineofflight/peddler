# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard text box block, comprised of a paragraph with a headline.
      StandardTextBlock = Structure.new do
        # @return [ParagraphComponent]
        attribute?(:body, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
