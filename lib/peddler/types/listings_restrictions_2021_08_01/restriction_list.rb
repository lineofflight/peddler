# frozen_string_literal: true

require "peddler/types/listings_restrictions_2021_08_01/restriction"

module Peddler
  module Types
    module ListingsRestrictions20210801
      # A list of restrictions for the specified Amazon catalog item.
      RestrictionList = Structure.new do
        # @return [Array<Restriction>]
        attribute(:restrictions, [Restriction])
      end
    end
  end
end
