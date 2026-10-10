# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Support20250201
      # A date range filter with optional before and after bounds. Dates must be in [ISO
      # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      DateFilter = Structure.new do
        # Include results with timestamps strictly after this value (exclusive).
        attribute?(:after, Time)

        # Include results with timestamps strictly before this value (exclusive).
        attribute?(:before, Time)
      end
    end
  end
end
