# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The state and country from where the item is shipped.
      ShipsFromType = Structure.new do
        # @return [String] The country from where the item is shipped.
        attribute?(:country, String, from: "Country")

        # @return [String] The state from where the item is shipped.
        attribute?(:state, String, from: "State")
      end
    end
  end
end
