# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      Points = Structure.new do
        # @return [Integer]
        attribute(:points_number, Integer, null: false, from: "PointsNumber")
      end
    end
  end
end
