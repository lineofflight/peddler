# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The state and country from where the item is shipped.
      ShipsFromType = Structure.new do
        # @return [String] The state from where the item is shipped.
        attribute(:state, String, from: "State")

        # @return [String] The country from where the item is shipped.
        attribute(:country, String, from: "Country")
      end
    end
  end
end
