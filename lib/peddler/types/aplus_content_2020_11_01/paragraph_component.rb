# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # A list of rich text content that is typically presented in a text box.
      ParagraphComponent = Structure.new do
        # @return [Array<TextComponent>]
        attribute(:text_list, [TextComponent], from: "textList")
      end
    end
  end
end
