# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Vehicles20241101
      # Represents a month in a specific year.
      MonthAndYear = Structure.new do
        # @return [Float]
        attribute?(:month, Float)

        # @return [Float]
        attribute?(:year, Float)
      end
    end
  end
end
