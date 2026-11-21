# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A decorator applied to a content string value in order to create rich text.
      Decorator = Structure.new do
        # The relative intensity or variation of this decorator. Decorators such as bullet-points, for example, can have
        # multiple indentation depths.
        attribute?(:depth, Integer)

        # The number of content characters to alter with this decorator. Decorators such as line breaks can have zero
        # length and fit between characters.
        attribute?(:length, Integer)

        # The starting character of this decorator within the content string. Use zero for the first character.
        attribute?(:offset, Integer)

        # Known values: `LIST_ITEM`, `LIST_ORDERED`, `LIST_UNORDERED`, `STYLE_BOLD`, `STYLE_ITALIC`, `STYLE_LINEBREAK`,
        # `STYLE_PARAGRAPH`, `STYLE_UNDERLINE`.
        attribute?(:type, String)
      end
    end
  end
end
