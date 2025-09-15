# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # The number of Amazon Points offered with the purchase of an item, and their monetary value. Note that the
      # `Points` element is only returned in Japan (JP).
      Points = Structure.new do
        # @return [Integer]
        attribute(:points_number, Integer, from: "pointsNumber")
      end
    end
  end
end
