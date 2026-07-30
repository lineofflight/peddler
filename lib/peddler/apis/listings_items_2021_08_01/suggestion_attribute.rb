# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # A key-value pair representing an attribute for suggestion generation.
      SuggestionAttribute = Structure.new do
        # @return [String] The attribute name.
        attribute(:key, String, null: false)

        # @return [String] The attribute value.
        attribute(:value, String, null: false)

        # @return [String] The language code for the attribute value. Must be an IETF language tag with underscores.
        attribute?(:language_tag, String)
      end
    end
  end
end
