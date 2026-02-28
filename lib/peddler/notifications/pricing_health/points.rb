# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # The number of Amazon Points offered with the purchase of an item
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points offered with the purchase of an item
        attribute(:points_number, Integer, null: false, from: "pointsNumber")
      end
    end
  end
end
