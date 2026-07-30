# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Source information for generating suggestions.
      SuggestionSource = Structure.new do
        # @return [Array<SuggestionAttribute>] List of key-value pairs representing suggestion input data.
        attribute(:attributes, [SuggestionAttribute], null: false)
      end
    end
  end
end
