# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsRestrictions20210801
      # A listing restriction, optionally qualified by a condition, with a list of reasons for the restriction.
      Restriction = Structure.new do
        # @return [String] A marketplace identifier. Identifies the Amazon marketplace where the restriction is
        #   enforced.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The condition that applies to the restriction.
        attribute?(:condition_type, String, from: "conditionType")

        # @return [Array<Reason>] A list of reasons for the restriction.
        attribute?(:reasons, [Reason])
      end
    end
  end
end
