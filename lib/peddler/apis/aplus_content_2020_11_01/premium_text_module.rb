# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A text-only module with headline and body text, allowing greater character limits than other modules for
      # explaining more details or instructions on your product.
      PremiumTextModule = Structure.new do
        # @return [ParagraphComponent]
        attribute(:description, ParagraphComponent, null: false)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
