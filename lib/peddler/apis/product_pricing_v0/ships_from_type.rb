# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # The state and country from where the item is shipped.
      ShipsFromType = Structure.new do
        # The country from where the item is shipped.
        attribute?(:country, String, from: "Country")

        # The state from where the item is shipped.
        attribute?(:state, String, from: "State")
      end
    end
  end
end
