# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points offered with the purchase of an item
        attribute(:points_number, Integer, from: "PointsNumber")
      end
    end
  end
end
