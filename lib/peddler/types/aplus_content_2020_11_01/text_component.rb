# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/decorator"

module Peddler
  module Types
    module AplusContent20201101
      # Rich text content.
      TextComponent = Structure.new do
        # @return [String] The actual plain text.
        attribute(:value, String)

        # @return [Array<Decorator>]
        attribute?(:decorator_set, [Decorator], from: "decoratorSet")
      end
    end
  end
end
