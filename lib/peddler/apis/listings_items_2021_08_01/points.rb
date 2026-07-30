# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The number of Amazon Points offered with the purchase of an item, and their monetary value. Note that the
      # `Points` element is only returned in Japan (JP).
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points offered with the purchase of an item, and their monetary value.
        attribute(:points_number, Integer, null: false, from: "pointsNumber")
      end
    end
  end
end
