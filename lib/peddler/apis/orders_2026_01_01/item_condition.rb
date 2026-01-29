# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Detailed information about the physical condition and quality state of the item being sold.
      ItemCondition = Structure.new do
        # @return [String] Additional details provided by the seller to describe the specific condition of this
        #   particular item.
        attribute?(:condition_note, String, from: "conditionNote")

        # @return [String] A more specific condition classification that provides additional detail about the item's
        #   quality within the main condition type.
        #
        # **Possible values**: `NEW`, `MINT`, `VERY_GOOD`, `GOOD`, `ACCEPTABLE`, `POOR`, `CLUB`, `OEM`, `WARRANTY`,
        #   `REFURBISHED_WARRANTY`, `REFURBISHED`, `OPEN_BOX`, `ANY`, `OTHER`.
        attribute?(:condition_subtype, String, from: "conditionSubtype")

        # @return [String] The primary condition category that broadly describes the item's state.
        #
        # **Possible values**: `NEW`, `USED`, `COLLECTIBLE`, `REFURBISHED`, `PREORDER`, `CLUB`.
        attribute?(:condition_type, String, from: "conditionType")
      end
    end
  end
end
