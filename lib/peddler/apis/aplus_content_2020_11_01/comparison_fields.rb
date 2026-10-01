# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single comparison field.
      ComparisonFields = Structure.new do
        # @return [PlainTextItem]
        attribute(:comparison_field, PlainTextItem, null: false, from: "comparisonField")
      end
    end
  end
end
