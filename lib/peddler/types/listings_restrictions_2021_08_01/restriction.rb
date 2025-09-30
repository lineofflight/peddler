# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/listings_restrictions_2021_08_01/reason"

module Peddler
  module Types
    module ListingsRestrictions20210801
      # A listing restriction, optionally qualified by a condition, with a list of reasons for the restriction.
      Restriction = Structure.new do
        # @return [String] A marketplace identifier. Identifies the Amazon marketplace where the restriction is
        # enforced.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The condition that applies to the restriction.
        attribute?(:condition_type, String, from: "conditionType")

        # @return [Array<Reason>] A list of reasons for the restriction.
        attribute?(:reasons, [Reason])
      end
    end
  end
end
