# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # The weight of the scheduled package
      Weight = Structure.new do
        # @return [String]
        attribute?(:unit, String)

        # @return [Float]
        attribute?(:value, Float)
      end
    end
  end
end
