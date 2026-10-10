# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Rich text content.
      TextComponent = Structure.new do
        # The actual plain text.
        attribute(:value, String, null: false)

        attribute?(:decorator_set, [Decorator], from: "decoratorSet")
      end
    end
  end
end
