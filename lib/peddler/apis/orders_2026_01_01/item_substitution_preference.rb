# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Substitution preference for an order item when it becomes unavailable during fulfillment.
      ItemSubstitutionPreference = Structure.new do
        # @return [String] Source and nature of the substitution preferences for this item.
        attribute(:substitution_type, String, from: "substitutionType")

        # @return [Array<ItemSubstitutionOption>] List of alternative products that can be substituted for the original
        #   item if it becomes unavailable.
        attribute?(:substitution_options, [ItemSubstitutionOption], from: "substitutionOptions")
      end
    end
  end
end
