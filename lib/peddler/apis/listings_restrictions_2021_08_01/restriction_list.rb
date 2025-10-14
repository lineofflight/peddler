# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsRestrictions20210801
      # A list of restrictions for the specified Amazon catalog item.
      RestrictionList = Structure.new do
        # @return [Array<Restriction>]
        attribute(:restrictions, [Restriction])
      end
    end
  end
end
