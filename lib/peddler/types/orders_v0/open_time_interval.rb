# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # The time when the business opens or closes.
      OpenTimeInterval = Structure.new do
        # @return [Integer] The hour when the business opens or closes.
        attribute?(:hour, Integer, from: "Hour")

        # @return [Integer] The minute when the business opens or closes.
        attribute?(:minute, Integer, from: "Minute")
      end
    end
  end
end
