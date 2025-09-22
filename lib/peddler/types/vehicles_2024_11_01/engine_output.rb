# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Vehicles20241101
      # Engine power output of vehicle.
      EngineOutput = Structure.new do
        # @return [Float] Engine power value in specified unit.
        attribute(:value, Float)

        # @return [String] Unit for measuring engine power.
        attribute(:unit, String)
      end
    end
  end
end
