# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/paragraph_component"
require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard text box block, which contains a paragraph and a headline.
      StandardTextBlock = Structure.new do
        # @return [ParagraphComponent]
        attribute?(:body, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
