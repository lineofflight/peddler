# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information related to the warehouse picking process for an order item.
      ItemPicking = Structure.new do
        # @return [ItemSubstitutionPreference] Substitution preference for an order item when it becomes unavailable
        #   during fulfillment
        attribute?(:substitution_preference, ItemSubstitutionPreference, from: "substitutionPreference")
      end
    end
  end
end
