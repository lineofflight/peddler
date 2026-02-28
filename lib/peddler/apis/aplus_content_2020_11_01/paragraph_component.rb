# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A list of rich text content that is typically presented in a text box.
      ParagraphComponent = Structure.new do
        # @return [Array<TextComponent>]
        attribute(:text_list, [TextComponent], null: false, from: "textList")
      end
    end
  end
end
