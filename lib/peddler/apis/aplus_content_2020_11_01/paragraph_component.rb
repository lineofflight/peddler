# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A list of rich text content, usually presented in a text box.
      ParagraphComponent = Structure.new do
        attribute(:text_list, [TextComponent], null: false, from: "textList")
      end
    end
  end
end
