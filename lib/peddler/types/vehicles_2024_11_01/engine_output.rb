# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Vehicles20241101
      # Engine power output of vehicle.
      EngineOutput = Structure.new do
        # @return [String] Unit for measuring engine power.
        attribute(:unit, String)

        # @return [Float] Engine power value in specified unit.
        attribute(:value, Float)
      end
    end
  end
end
