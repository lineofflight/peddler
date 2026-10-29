# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # A single search refinement value with its display name and result count.
      SearchRefinementValue = Structure.new do
        # @return [Integer] The number of results matching this refinement value.
        attribute(:count, Integer, null: false)

        # @return [String] The localized display name for this refinement value.
        attribute(:display_name, String, null: false, from: "displayName")

        # @return [String] The value to supply as a filter to refine the result set.
        attribute(:value, String, null: false)
      end
    end
  end
end
