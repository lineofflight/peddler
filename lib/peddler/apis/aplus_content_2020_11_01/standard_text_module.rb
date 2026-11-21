# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A standard headline and body text.
      StandardTextModule = Structure.new do
        attribute(:body, ParagraphComponent, null: false)

        attribute?(:headline, TextComponent)
      end
    end
  end
end
