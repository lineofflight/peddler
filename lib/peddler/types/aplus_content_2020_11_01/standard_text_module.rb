# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/paragraph_component"

module Peddler
  module Types
    module AplusContent20201101
      # A standard headline and body text.
      StandardTextModule = Structure.new do
        # @return [TextComponent]
        attribute(:headline, TextComponent)

        # @return [ParagraphComponent]
        attribute(:body, ParagraphComponent)
      end
    end
  end
end
