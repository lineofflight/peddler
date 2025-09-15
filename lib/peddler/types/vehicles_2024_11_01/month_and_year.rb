# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Vehicles20241101
      # Represents a month in a specific year.
      MonthAndYear = Structure.new do
        # @return [Float]
        attribute(:year, Float)

        # @return [Float]
        attribute(:month, Float)
      end
    end
  end
end
