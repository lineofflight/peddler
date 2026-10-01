# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Support20250201
      # A date range filter with optional before and after bounds. Dates must be in
      # {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      DateFilter = Structure.new do
        # @return [Time] Include results with timestamps strictly after this value (exclusive).
        attribute?(:after, Time)

        # @return [Time] Include results with timestamps strictly before this value (exclusive).
        attribute?(:before, Time)
      end
    end
  end
end
