# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsRestrictions20210801
      # A list of restrictions for the specified Amazon catalog item.
      RestrictionList = Structure.new do
        # A list of restrictions.
        attribute(:restrictions, [Restriction], null: false)
      end
    end
  end
end
