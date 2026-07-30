# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The request body schema for generating attribute suggestions.
      ListingsItemSuggestionRequest = Structure.new do
        # @return [Array<SuggestionSource>] List of input sources.
        attribute(:sources, [SuggestionSource], null: false)
      end
    end
  end
end
