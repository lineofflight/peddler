# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      # A decorator that is applied to a content string value in order to create rich text.
      Decorator = Structure.new do
        # @return [String]
        attribute(:type, String)

        # @return [Integer] The starting value of this decorator within the content string. Use zero (`0`) for the first
        # value.
        attribute(:offset, Integer)

        # @return [Integer] The number of content characters to alter with this decorator. Decorators, such as line
        # breaks, can have zero length and fit between characters.
        attribute(:length, Integer)

        # @return [Integer] The relative intensity or variation of this decorator. Decorators, such as bullet-points,
        # can have multiple indentation depths.
        attribute(:depth, Integer)
      end
    end
  end
end
