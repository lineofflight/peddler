# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single technical specification with a key-value pair.
      TechSpec = Structure.new do
        # @return [TextComponent]
        attribute(:spec_key, TextComponent, null: false, from: "specKey")

        # @return [TextComponent]
        attribute(:spec_value, TextComponent, null: false, from: "specValue")
      end
    end
  end
end
