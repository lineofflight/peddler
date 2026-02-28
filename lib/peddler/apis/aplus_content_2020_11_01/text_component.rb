# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Rich text content.
      TextComponent = Structure.new do
        # @return [String] The actual plain text.
        attribute(:value, String, null: false)

        # @return [Array<Decorator>]
        attribute?(:decorator_set, [Decorator], from: "decoratorSet")
      end
    end
  end
end
