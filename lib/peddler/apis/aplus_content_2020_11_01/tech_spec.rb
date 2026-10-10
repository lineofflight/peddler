# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single technical specification with a key-value pair.
      TechSpec = Structure.new do
        attribute(:spec_key, TextComponent, null: false, from: "specKey")

        attribute(:spec_value, TextComponent, null: false, from: "specValue")
      end
    end
  end
end
