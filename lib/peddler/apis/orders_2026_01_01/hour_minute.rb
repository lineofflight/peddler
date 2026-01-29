# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The time when the business opens or closes.
      HourMinute = Structure.new do
        # @return [Integer] The hour when the business opens or closes, in 24-hour format (0-23).
        attribute?(:hour, Integer)

        # @return [Integer] The minute when the business opens or closes.
        attribute?(:minute, Integer)
      end
    end
  end
end
