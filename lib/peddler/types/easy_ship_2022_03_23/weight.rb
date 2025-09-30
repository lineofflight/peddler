# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module EasyShip20220323
      # The weight of the scheduled package
      Weight = Structure.new do
        # @return [Float]
        attribute?(:value, Float)

        # @return [String]
        attribute?(:unit, String)
      end
    end
  end
end
