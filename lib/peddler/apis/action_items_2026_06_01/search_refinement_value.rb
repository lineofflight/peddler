# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # A refinement value with its count in the full filtered result set.
      SearchRefinementValue = Structure.new do
        # Number of results matching this refinement value.
        attribute(:count, Integer, null: false)

        # Human-readable label for the refinement value.
        attribute(:display_name, String, null: false, from: "displayName")

        # The refinement value to pass back as a filter.
        attribute(:value, String, null: false)
      end
    end
  end
end
